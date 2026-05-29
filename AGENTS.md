AGENTS

This file gives concise, actionable rules and commands for automated agents (and humans) working in this repository.
Follow these exactly unless a change is justified and recorded in the git history.

- Repository root: `flake.nix` defines flake inputs and outputs; hosts are in `hosts/`; reusable code is in `modules/` and `parts/`.

Build / Lint / Test (quick commands)
- Build the flake outputs (all default outputs):
  ```bash
  nix build .#
  ```
- Show available flake outputs (useful to discover tests/checks):
  ```bash
  nix flake show
  ```
- Run the flake's checks (if configured):
  ```bash
  nix flake check
  ```
- Build a single test or check output (common patterns):
  1. List outputs with `nix flake show` and find the test/check name (examples: `nixosTests`, `checks`, `packages`).
  2. Build that single output:
     ```bash
     nix build .#nixosTests.<TestName>
     # or
     nix build .#checks.<CheckName>
     # or
     nix build .#tests.<Name>
     ```
  Use the exact label printed by `nix flake show`.
- Run a NixOS test (if present) directly with `nix run` / `nix build` depending on the flake outputs; for interactive debugging use `nix develop` to drop into the developer shell.
  ```bash
  nix develop
  ```

Formatting & Linting
- Format Nix files with `nixpkgs-fmt` (preferred) or `alejandra` for more opinions:
  ```bash
  # format whole repo (from repo root)
  find . -name '*.nix' -print0 | xargs -0 nixpkgs-fmt
  # or, if you prefer alejandra (may require a dev shell):
  alejandro --format .
  ```
- Use `nix flake show` and `nix build` to validate builds after formatting.
- Shell scripts: use `shellcheck` and format with `shfmt`:
  ```bash
  shellcheck **/*.sh || true
  shfmt -w **/*.sh || true
  ```
- YAML/JSON: use `yamllint`, `prettier` or `jq` for JSON validation. Example:
  ```bash
  jq . somefile.json >/dev/null
  yamllint -c .yamllint.yaml somefile.yaml || true
  ```

Running a single test (precise recipe)
- Step 1: inspect flake outputs and names
  ```bash
  nix flake show --json | jq '.'
  ```
- Step 2: pick the correct output name (example `nixosTests.myTest`) and build only that output:
  ```bash
  nix build .#nixosTests.myTest
  ```
- If the test is a `checks.<name>` output use that path instead. If a test needs extra runtime dependencies open a `nix develop` session and run the test binary from inside the devshell.

Code Style Guidelines (for agents)
- General
  - Prefer clarity over cleverness. Small, explicit expressions are better than large, dense ones.
  - Keep changes minimal: when editing a file to fix a bug or style, make the smallest change that fully addresses the issue.
  - Do not modify unrelated files. If a change touches many files, explain why in the commit message.

- Nix files (.nix)
  - Indentation: 2 spaces.
  - File layout: top-level attribute sets or function definitions; use `let` for local bindings and keep them near where they're used.
  - Imports: use relative paths for local items (`./modules/foo.nix`) and `inputs.<name>` for flake inputs. Avoid absolute paths.
  - Naming: use kebab-case for file names (`some-module.nix`) and camelCase or snake_case for attributes depending on the surrounding convention — follow the file you edit.
  - Options & modules: prefer `lib.mkOption`, `mkIf`, and `mkEnableOption` for boolean options and follow existing patterns in `modules/`.
  - Avoid duplicated evaluation of heavy expressions — bind them to a local name once and reuse.
  - Comments: write short comments for non-obvious logic. Put module-level docs at the top of the file.

- Nix attribute conventions
  - `config`, `pkgs`, `lib`, `systems` are commonly passed in module function args — prefer those names.
  - Keep module interfaces small; export configuration via options, not by side-effects.

- Shell scripts
  - Use `set -euo pipefail` at the top of scripts.
  - Quote expansions; prefer `printf` over `echo` when the output may start with `-` or contain backslashes.
  - Validate important environment variables with explicit checks and helpful error messages.
  - Prefer POSIX shells for portability unless the file explicitly targets bash or zsh.

- Naming conventions
  - Files/dirs: kebab-case
  - Nix attributes: kebab-case or camelCase depending on nearby code — mirror existing style in that directory.
  - Function/variable names in small scripts: snake_case

- Formatting
  - Run `nixpkgs-fmt` before committing any `.nix` change.
  - Run `shfmt` for shell scripts and `prettier`/`jq` for JSON/YAML where applicable.

- Types & Safety
  - Nix is dynamically typed but be explicit with expected shapes. Use attribute-set checks or `assert` to fail fast when required inputs are missing.
  - Example: `assert builtins.isAttrs cfg or builtins.isNull cfg;` — prefer human-friendly messages with `assert <cond> || builtins.trace` when debugging.

- Error handling
  - Use `assert` for fatal misconfiguration, with a short explanatory message.
  - Prefer failing fast: do not attempt complex recovery inside flakes or modules; surface errors clearly to the caller.
  - For shell code, propagate errors upward (no silent fallbacks) unless explicitly documented.

Repository discipline and safety
- Secrets: this repo already contains `secrets.yaml` and `.sops.yaml`. Agents must never print, transmit, or commit secrets. If you need to use secrets, use the repository's SOPS workflow and do not add raw secrets to commits.
- Pre-commit and hooks: there are samples in `.git/hooks/`. If you add git hooks, commit them to `.githooks/` and document their installation. Do not bypass hooks.
- Commits & PRs
  - Commit messages: one-line summary (imperative) followed by a short body when needed. Explain why, not just what.
  - Do not force-push main branches. If a rebase is necessary, prefer a separate branch and open a PR.

Tooling notes for agents
- If you need formatting or lint tools not present locally, open a `nix develop` session to load them (flake-provided devShell) or use `nix run`:
  ```bash
  nix run nixpkgs#nixpkgs-fmt -- <file>
  ```
- Use `nix flake show` to discover outputs and which commands make sense for this flake.

Cursor/Copilot rules
- No repository-level Cursor rules were found in `.cursor/rules/` or top-level `.cursorrules`.
- No Copilot instructions were found in `.github/copilot-instructions.md`.
  If such files are added later, follow their contents strictly and add a reference to this document.

Final checklist for automated agents before creating a PR
- Run `nixpkgs-fmt` on changed `.nix` files.
- Run `shfmt`/`shellcheck` on changed shell scripts.
- Ensure no secrets are staged.
- Run `nix build .#` or `nix flake check` if your change touches build logic.

If you are blocked or something is ambiguous: pick the least-surprising option (minimal change that keeps the build green) and note the choice in the commit message.

Reference files to inspect:
- `flake.nix` (root): flake inputs/outputs
- `hosts/` (hosts): system configurations
- `modules/` (re-usable code): main library
- `parts/` (helpers): helper code used by the flake

Thank you — be conservative, write small changes, and keep the flake working.
