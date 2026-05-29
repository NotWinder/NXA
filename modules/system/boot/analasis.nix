# boot-monitor.nix
# Add to your configuration.nix with: imports = [ ./boot-monitor.nix ];
{
  config,
  lib,
  pkgs,
  ...
}: let
  # The main monitoring script
  bootMonitorScript = pkgs.writeShellScriptBin "boot-monitor" ''
    set -euo pipefail

    MONITOR_DIR="/var/log/boot-monitor"
    BOOT_ID=$(${pkgs.coreutils}/bin/cat /proc/sys/kernel/random/boot_id)
    TIMESTAMP=$(${pkgs.coreutils}/bin/date +%Y%m%d_%H%M%S)
    LOG_FILE="$MONITOR_DIR/boot_''${TIMESTAMP}_''${BOOT_ID:0:8}.log"

    ${pkgs.coreutils}/bin/mkdir -p "$MONITOR_DIR"

    log() {
        echo "[$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S.%3N')] $*" | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
    }

    get_temps() {
        local temps=""
        for temp_input in /sys/class/hwmon/hwmon*/temp*_input; do
            [ -f "$temp_input" ] || continue
            local temp_label="''${temp_input%_input}_label"
            local label="Unknown"
            [ -f "$temp_label" ] && label=$(${pkgs.coreutils}/bin/cat "$temp_label")
            local temp=$(($(${pkgs.coreutils}/bin/cat "$temp_input") / 1000))
            temps="''${temps}''${label}: ''${temp}°C | "
        done

        for zone in /sys/class/thermal/thermal_zone*/temp; do
            [ -f "$zone" ] || continue
            local zone_type="''${zone%/temp}/type"
            local type="Zone"
            [ -f "$zone_type" ] && type=$(${pkgs.coreutils}/bin/cat "$zone_type")
            local temp=$(($(${pkgs.coreutils}/bin/cat "$zone") / 1000))
            temps="''${temps}''${type}: ''${temp}°C | "
        done

        echo "''${temps%| }"
    }

    get_cpu_freq() {
        local freqs="" count=0
        for freq in /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq; do
            [ -f "$freq" ] || continue
            local mhz=$(($(${pkgs.coreutils}/bin/cat "$freq") / 1000))
            freqs="''${freqs}CPU''${count}:''${mhz}MHz "
            ((count++))
        done
        echo "$freqs"
    }

    get_top_procs() {
        ${pkgs.procps}/bin/ps aux --sort=-%cpu | ${pkgs.coreutils}/bin/head -6 | ${pkgs.coreutils}/bin/tail -n +2 | ${pkgs.gawk}/bin/awk '{printf "%s(%.1f%%) ", $11, $3}'
    }

    get_io_stats() {
        if command -v ${pkgs.sysstat}/bin/iostat &> /dev/null; then
            ${pkgs.sysstat}/bin/iostat -x 1 1 | ${pkgs.gnugrep}/bin/grep -E 'nvme|sd' | ${pkgs.gawk}/bin/awk '{printf "%s:r=%s,w=%s ", $1, $6, $7}'
        else
            echo "iostat not available"
        fi
    }

    DURATION=''${1:-60}
    INTERVAL=''${2:-2}
    end_time=$(($({pkgs.coreutils}/bin/date +%s) + DURATION))

    log "=== Boot Monitor Started ==="
    log "Boot ID: $BOOT_ID"
    log "Uptime: $(${pkgs.procps}/bin/uptime -p)"
    log "Memory: $(${pkgs.procps}/bin/free -h | ${pkgs.gnugrep}/bin/grep Mem | ${pkgs.gawk}/bin/awk '{print $3 "/" $2}')"
    log ""

    sample=0
    while [ $(${pkgs.coreutils}/bin/date +%s) -lt $end_time ]; do
        ((sample++))
        uptime_sec=$(($(${pkgs.coreutils}/bin/date +%s) - (end_time - DURATION)))
        log "--- Sample $sample (T+''${uptime_sec}s) ---"
        log "Temps: $(get_temps)"
        log "Freq: $(get_cpu_freq)"
        log "Top: $(get_top_procs)"
        log "Load: $(${pkgs.coreutils}/bin/cat /proc/loadavg | ${pkgs.gawk}/bin/awk '{print $1 "," $2 "," $3}')"

        # ZFS stats every 5 samples
        if [ $((sample % 5)) -eq 0 ]; then
            log "ZFS ARC: $(${pkgs.gnugrep}/bin/grep -E 'size|hits|misses' /proc/spl/kstat/zfs/arcstats | ${pkgs.coreutils}/bin/head -3 | ${pkgs.gawk}/bin/awk '{print $1 "=" $3}' | ${pkgs.coreutils}/bin/tr '\n' ' ')"
        fi

        log ""
        ${pkgs.coreutils}/bin/sleep "$INTERVAL"
    done

    log "=== Monitoring Complete ==="
    log ""
    log "--- Systemd Analysis ---"
    ${pkgs.systemd}/bin/systemd-analyze | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
    log ""
    log "--- Critical Chain ---"
    ${pkgs.systemd}/bin/systemd-analyze critical-chain | ${pkgs.coreutils}/bin/head -20 | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
    log ""
    log "--- Slowest Services ---"
    ${pkgs.systemd}/bin/systemd-analyze blame | ${pkgs.coreutils}/bin/head -20 | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
    log ""

    log "--- Boot Errors/Warnings ---"
    ${pkgs.systemd}/bin/journalctl -b -p warning | ${pkgs.coreutils}/bin/tail -20 | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
    log ""

    log "--- ZFS Status ---"
    ${pkgs.zfs}/bin/zpool iostat -v | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
    log ""

    # Summary
    peak_temp=$(${pkgs.gnugrep}/bin/grep "Temps:" "$LOG_FILE" | ${pkgs.gnugrep}/bin/grep -oP 'Tctl: \K[0-9]+' | ${pkgs.coreutils}/bin/sort -n | ${pkgs.coreutils}/bin/tail -1 || echo "N/A")
    max_load=$(${pkgs.gnugrep}/bin/grep "Load:" "$LOG_FILE" | ${pkgs.gawk}/bin/awk '{print $NF}' | ${pkgs.coreutils}/bin/cut -d',' -f1 | ${pkgs.coreutils}/bin/sort -n | ${pkgs.coreutils}/bin/tail -1 || echo "N/A")

    log "=== SUMMARY ==="
    log "Peak Temperature: ''${peak_temp}°C"
    log "Max Load Average: $max_load"
    log "Log saved to: $LOG_FILE"

    echo ""
    echo "✓ Monitoring complete!"
    echo "Log: $LOG_FILE"
    echo "Run: analyze-boot to see detailed report"
  '';

  # The analysis script
  analyzeBootScript = pkgs.writeShellScriptBin "analyze-boot" ''
    set -euo pipefail

    MONITOR_DIR="/var/log/boot-monitor"

    if [ ! -d "$MONITOR_DIR" ]; then
        echo "Error: Monitor directory not found at $MONITOR_DIR"
        exit 1
    fi

    LATEST_LOG=$(${pkgs.coreutils}/bin/ls -t "$MONITOR_DIR"/boot_*.log 2>/dev/null | ${pkgs.coreutils}/bin/head -1)

    if [ -z "$LATEST_LOG" ]; then
        echo "No log files found. Run: sudo boot-monitor"
        exit 1
    fi

    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║           Boot Performance Analysis Report                     ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Analyzing: $(${pkgs.coreutils}/bin/basename "$LATEST_LOG")"
    echo "Created: $(${pkgs.coreutils}/bin/stat -c %y "$LATEST_LOG" | ${pkgs.coreutils}/bin/cut -d. -f1)"
    echo ""

    # Temperature analysis
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🌡️  TEMPERATURE ANALYSIS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ${pkgs.gnugrep}/bin/grep -q "Tctl:" "$LATEST_LOG"; then
        TEMPS=$(${pkgs.gnugrep}/bin/grep "Temps:" "$LATEST_LOG" | ${pkgs.gnugrep}/bin/grep -oP 'Tctl: \K[0-9]+' | ${pkgs.coreutils}/bin/sort -n)
        MIN_TEMP=$(echo "$TEMPS" | ${pkgs.coreutils}/bin/head -1)
        MAX_TEMP=$(echo "$TEMPS" | ${pkgs.coreutils}/bin/tail -1)
        AVG_TEMP=$(echo "$TEMPS" | ${pkgs.gawk}/bin/awk '{sum+=$1} END {printf "%.0f", sum/NR}')

        echo "  Tctl (CPU Die):"
        echo "    Min: ''${MIN_TEMP}°C"
        echo "    Max: ''${MAX_TEMP}°C"
        echo "    Avg: ''${AVG_TEMP}°C"

        if [ "$MAX_TEMP" -gt 80 ]; then
            echo "    ⚠️  WARNING: Peak temperature exceeds 80°C!"
        elif [ "$MAX_TEMP" -gt 70 ]; then
            echo "    ⚠️  Temperature spike detected (>70°C)"
        fi
    fi

    echo ""

    # CPU frequency analysis
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚡ CPU FREQUENCY ANALYSIS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ${pkgs.gnugrep}/bin/grep -q "Freq:" "$LATEST_LOG"; then
        FREQS=$(${pkgs.gnugrep}/bin/grep "Freq:" "$LATEST_LOG" | ${pkgs.gnugrep}/bin/grep -oP 'CPU0:\K[0-9]+' | ${pkgs.coreutils}/bin/sort -n)
        MIN_FREQ=$(echo "$FREQS" | ${pkgs.coreutils}/bin/head -1)
        MAX_FREQ=$(echo "$FREQS" | ${pkgs.coreutils}/bin/tail -1)
        AVG_FREQ=$(echo "$FREQS" | ${pkgs.gawk}/bin/awk '{sum+=$1} END {printf "%.0f", sum/NR}')

        echo "  CPU0 Frequency:"
        echo "    Min: ''${MIN_FREQ} MHz"
        echo "    Max: ''${MAX_FREQ} MHz"
        echo "    Avg: ''${AVG_FREQ} MHz"

        if [ "$MAX_FREQ" -lt 2000 ]; then
            echo "    ⚠️  Possible throttling detected (max <2GHz)"
        fi
    fi

    echo ""

    # Timeline
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📈 TEMPERATURE TIMELINE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ${pkgs.gnugrep}/bin/grep -q "Tctl:" "$LATEST_LOG"; then
        echo ""
        ${pkgs.gnugrep}/bin/grep "Sample" "$LATEST_LOG" -A 1 | ${pkgs.gnugrep}/bin/grep "Temps:" | ${pkgs.gnugrep}/bin/grep -oP 'Tctl: \K[0-9]+' | \
        ${pkgs.gawk}/bin/awk 'BEGIN {
            print "  Time  Temp  Chart"
            print "  ----  ----  ----------------------------------------"
        }
        {
            sample = NR * 2;
            temp = $1;
            bars = int(temp / 2);
            printf "  %3ds  %3d°C ", sample, temp;
            for(i=0; i<bars; i++) printf "▓";
            print "";
        }'
        echo ""
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Full log: $LATEST_LOG"
    echo ""
  '';
in {
  # Module configuration
  options = {
    services.bootMonitor = {
      enable = lib.mkEnableOption "boot performance monitoring";

      monitorDuration = lib.mkOption {
        type = lib.types.int;
        default = 60;
        description = "Duration to monitor in seconds";
      };

      monitorInterval = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Sampling interval in seconds";
      };

      enableResumeMonitor = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable monitoring on resume from suspend";
      };

      keepLogs = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Number of logs to keep";
      };
    };
  };

  config = lib.mkIf config.services.bootMonitor.enable {
    # Add scripts to system packages
    environment.systemPackages = [
      bootMonitorScript
      analyzeBootScript
      pkgs.sysstat # For iostat
      pkgs.lm_sensors # For sensors command
    ];

    # Create log directory
    systemd.tmpfiles.rules = [
      "d /var/log/boot-monitor 0755 root root -"
    ];

    # Boot monitoring service
    systemd.services.boot-performance-monitor = {
      description = "Boot Performance Monitor";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${bootMonitorScript}/bin/boot-monitor ${toString config.services.bootMonitor.monitorDuration} ${toString config.services.bootMonitor.monitorInterval}";
        RemainAfterExit = false;
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    # Resume monitoring service
    systemd.services.resume-performance-monitor = lib.mkIf config.services.bootMonitor.enableResumeMonitor {
      description = "Resume from Suspend Performance Monitor";
      after = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 3 && ${bootMonitorScript}/bin/boot-monitor 30 1'";
        RemainAfterExit = false;
      };
    };

    # Cleanup old logs
    systemd.services.boot-monitor-cleanup = {
      description = "Cleanup old boot monitor logs";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'cd /var/log/boot-monitor && ${pkgs.coreutils}/bin/ls -t boot_*.log 2>/dev/null | ${pkgs.coreutils}/bin/tail -n +${toString (config.services.bootMonitor.keepLogs + 1)} | ${pkgs.findutils}/bin/xargs -r ${pkgs.coreutils}/bin/rm'";
      };
    };

    systemd.timers.boot-monitor-cleanup = {
      description = "Cleanup old boot monitor logs timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "1d";
      };
    };
  };
}
