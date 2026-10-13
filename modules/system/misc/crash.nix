{
  systemd = {
    # Kernel logs in pstore can contain sensitive information; kept on because
    # they're the only record of a panic. A hardened host can drop these rules.
    tmpfiles.rules = [
      # Enables storing of the kernel log (including stack trace) into pstore upon a panic or crash.
      "w /sys/module/kernel/parameters/crash_kexec_post_notifiers - - - - Y"
      # Enables storing of the kernel log upon a normal shutdown (shutdown, reboot, halt).
      "w /sys/module/printk/parameters/always_kmsg_dump - - - - N"
    ];
  };
}
