# Changelog

All notable changes to **xPsiphon** are documented in this file.

[فارسی](CHANGELOG.fa.md) | English

---

## [2.1.0] — 2026-09-11

This release adds a **JSON HTTP API** and **multi-distribution installer
support**, so xPsiphon runs on more than Ubuntu and can be controlled
programmatically. No new dependencies.

### Added

- **Multi-distribution installer support** — `install.sh` now detects the host
  package manager and installs prerequisites through it:
  - `apt-get` (Debian, Ubuntu, Linux Mint, Pop!_OS)
  - `dnf` (Fedora, RHEL 8+, AlmaLinux, Rocky Linux)
  - `yum` (CentOS 7)
  - `zypper` (openSUSE Leap / Tumbleweed)
  - `pacman` (Arch Linux, Manjaro — `python3` is mapped to `python`)
  - `apk` (Alpine Linux — installs `bash`, which this installer requires, and
    `procps` for a full process table)
- **Architecture validation** — the online install path fails early with a clear
  message on non-x86_64 systems, because the upstream Psiphon core binaries are
  x86_64 only.
- **SELinux labeling** — installed binaries are relabeled (`chcon -t bin_t`) on a
  best-effort basis, so execution is not blocked on RHEL / AlmaLinux / Rocky /
  Fedora in Enforcing mode.
- **`/proc` process-metrics fallback** — when `ps -o` is unavailable or does not
  support the requested format (minimal containers, BusyBox), CPU%, memory%,
  RSS and uptime are read from `/proc/<pid>` directly, so the status table stays
  populated instead of showing blank columns.
- **HTTP API** — a small JSON API over the same core functions the CLI and the
  panel use, built on the Python standard library only:
  - `GET /` (endpoint index), `/api/version`, `/api/status`, `/api/locations`,
    `/api/logs/{LOC}`, `/api/autostart`, `/api/doctor`
  - `POST /api/start/{LOC|all}`, `/api/stop/{LOC|all}`, `/api/restart/{LOC|all}`,
    `/api/test/{LOC|all}`, `/api/autostart/{on|off|toggle}`, `/api/port/{LOC}`
- **API authentication** — a token generated on first use and stored in
  `/etc/psiphon/api-token` with `0600` permissions. Accepted as
  `Authorization: Bearer`, `X-Api-Token`, or `?token=`. Comparison is
  constant-time. `XPSIPHON_API_TOKEN` overrides the file.
- **API service management** — `xp api serve` (foreground) and
  `sudo xp api start|stop|restart|status` (systemd service
  `xpsiphon-api.service`), plus an `A) API server` entry in the panel. The API
  binds to `127.0.0.1:8900` by default (loopback only).
- Per-endpoint hardening: a 64 KiB request-body limit and clear `400`/`401`/
  `403`/`404`/`413` responses.
- **Old-python distros handled** — distributions whose `python3` package is
  still 3.6 (RHEL/AlmaLinux 8, openSUSE Leap 15, CentOS 7) used to install
  "successfully" and then leave a manager that crashes on import. The installer
  now verifies the interpreter against the real floor after installing, and on
  those families attempts a versioned one (`python39` on dnf/yum, `python311`
  on zypper), exposing it as `python3` in `/usr/local/bin` (with `hash -r` so
  the same shell does not keep the stale path).
- **`sudo xp ...` works on RHEL-family distros** — RHEL, AlmaLinux, Rocky and
  CentOS use a sudo `secure_path` without `/usr/local/bin`, so the documented
  commands failed there with "command not found". The installer now adds
  `/usr/bin/xpsiphon` and `/usr/bin/xp` aliases (and uninstall removes them).
- **Manager runs on the interpreter the installer picked** — on openSUSE Leap,
  sudo resolves `python3` to the old 3.6 even after the shim, so the installed
  manager now carries the resolved interpreter path in its shebang.
- **`uninstall --purge` removes the API token** — `/etc/psiphon/api-token` is a
  credential on disk and was left behind, which also kept `/etc/psiphon` alive
  after a purge. A non-purge uninstall now tells you it was kept.
- A test suite under `tests/` (installer branches, architecture gate, offline
  end-to-end install, process lifecycle, HTTP API), runnable with
  `sudo bash tests/run_all.sh`. Verified end to end on real servers:
  openSUSE Leap 15.4, AlmaLinux 9 (SELinux Enforcing), Debian 12 and
  Ubuntu 22.04 — with live tunnels on the Netherlands servers (HTTP 204,
  ~100–280 ms, 1.4–2.4 MB/s through SOCKS).

### Changed

- `doctor` accepts **Python 3.8+** instead of 3.10+ — 3.8 is the version the
  code actually needs (`Path.unlink(missing_ok=)` is 3.8+), verified by running
  the manager's real code paths under 3.7, 3.8, 3.9, 3.10 and 3.12. This no
  longer reports a false failure on Debian 11 (3.9) or RHEL 9 / AlmaLinux 9
  (3.9), which ship Python 3.9 by default.
- `doctor` checks were extracted into `doctor_checks()` so the CLI and the API
  report the same result; `/api/doctor` ignores the systemd-only checks, which
  are not failures for a non-systemd install.
- `start_location` / `stop_location` / `restart_location` now return messages
  alongside their status, so both the CLI and the API can report what happened.
- The API and the supported distributions are documented in `README.md` and
  `README.fa.md`.

### Fixed

- `doctor` raised `NameError: name 'locations' is not defined` — a regression
  introduced while extracting `doctor_checks()`.
- The API request log wrote the token in plaintext when auth used `?token=`;
  the query value is now redacted.
- `locations_running` in `/api/status` counted processes rather than distinct
  running locations. It now counts locations, and `processes_running` was added
  for the per-process total.

### Security

A dedicated security pass (threat model → review → exploit reproduction →
patch → re-attack verification) found and fixed seven issues. Full details in
[SECURITY.md](SECURITY.md). Risk posture: **7.1 → 2.6**.

- **Removed the `?token=` query-parameter form of API authentication.** A
  token in the URL is world-readable through `/proc/<pid>/cmdline` for every
  local user, and persists in shell history. Header forms
  (`Authorization: Bearer`, `X-Api-Token`) are unaffected; query tokens now
  get `401`.
- **Added per-source throttling of failed API authentication.** More than 10
  failed attempts within 60 seconds from one address get `429`; a successful
  authentication clears the counter.
- **API token file is now created with `0600` from the start.** It was
  previously written with the default umask and only chmod'ed afterwards,
  leaving a world-readable window on multi-user hosts.
- **Runtime directories are validated before use.** The default data root
  (`/tmp/psiphon`) lives in a world-writable directory; a local user could
  pre-create it (or plant symlinks inside it) so that root-run tunnels write
  into attacker-chosen locations — reproduced in a container, with the tunnel
  datastore landing in `/etc` through an attacker symlink. The manager now
  refuses directories that are not owned by the current user or are
  group/world-writable, and creates the data root with `0700`.
- **systemd sandboxing for both units.** `NoNewPrivileges`,
  `ProtectSystem=strict`, `ProtectHome`, `MemoryDenyWriteExecute`,
  `RestrictSUIDSGID`, kernel-protection flags and a bounded `ReadWritePaths`
  are now written into `xpsiphon.service` and `xpsiphon-api.service`. Verified
  on a SELinux-Enforcing server that tunnels still start and connect under the
  sandbox (HTTP 204, 92 ms). `PrivateTmp` stays off so systemd-started tunnels
  share the same data root as CLI-started ones.
- **Download integrity baseline.** The Psiphon core binary is executed as
  root, so the installer now verifies a plausible size and the ELF header
  (magic + x86-64 machine type) before installing it. Upstream publishes no
  checksums; full pinning remains a documented tradeoff.
- **Atomic config writes.** Port changes write to a temp file and `os.replace`
  it, so a crash cannot leave a truncated config.

### Credits

- The **multi-distribution compatibility** work was proposed by
  [@mohammadaz2](https://github.com/mohammadaz2) in
  [PR #1](https://github.com/IzumiRain/xPsiphon/pull/1). The direction was
  adopted, but that patch was not merged as-is: it configured `GOGC=50` and
  `GOMEMLIMIT=45MiB` as mandatory defaults on every install without
  benchmarking, and its Alpine path could not actually run (the installer needs
  `bash`, which Alpine does not ship by default). The feature was reimplemented
  on top of the current code base, with `XPSIPHON_GOGC`/`XPSIPHON_GOMEMLIMIT`
  supported as explicit **opt-in** overrides rather than forced defaults.
  Thanks for the original idea and the push in this direction.

---

## [2.0.0] — 2026-07-07

A major update focused on **more locations**, **safe non-disruptive updates**,
and **easier maintenance**. Existing installs can upgrade without losing configs,
custom ports, or running tunnels.

### Added

- **7 new country locations** — `AU`, `ES`, `ID`, `IE`, `LT`, `RS`, `SG`.
  The full country list is now **28 egress regions** plus `AUTO`.
- **Customizable per-location ports** — change a location's SOCKS/HTTP port from
  the CLI (`sudo xp port US --socks 1201 --http 8201`) or from the panel
  (`p) Change location port`). Conflicting or out-of-range ports are rejected.
- **In-place update** — `sudo xp update` (and `u)` in the panel) updates
  xPsiphon **without disrupting a running setup**: existing configs and custom
  ports are kept, the core binary is not re-downloaded, running tunnels are not
  stopped, and only new location configs are added.
- **Uninstall** — `sudo xp uninstall` (and `x)` in the panel) cleanly removes
  the commands, the `systemd` service, and runtime directories. `--purge` also
  removes configs and the binary; `--yes` skips the confirmation prompt.
- **`version` command** — `xp version` prints the installed version, which is
  also shown in the panel header and in `xp doctor`.

### Changed

- Egress regions were **verified against the live Psiphon client** (the
  `AvailableEgressRegions` set reported by `psiphon-tunnel-core` on the same
  propagation channel these configs use), instead of relying on older
  third-party lists.
- Ports are now **frozen and stable across updates** — new locations always take
  the next free port instead of renumbering existing ones, so your firewall
  rules keep working after an update.

### Notes

- `BG` (Bulgaria) and `EE` (Estonia) are kept as **legacy** locations for
  backward compatibility, but were **not** in the current live region set. They
  are harmless if unused and can be deleted safely.
- `sudo xp update` fetches from GitHub `main`. Until this release is on `main`,
  existing users should update with the one-line installer (which is
  non-disruptive in the same way).

---

## [1.0.0] — 2026-06-24

First public release.

### Added

- One-line bootstrap installer for a fresh Ubuntu server: installs the Psiphon
  tunnel core, the `xpsiphon` manager, the short `xp` alias, and generated
  location configs.
- Dependency-free Python 3 management panel (interactive TUI).
- `AUTO` location plus 21 country locations, each on its own SOCKS/HTTP ports so
  multiple locations can run at the same time.
- Per-location processes, logs, PID files, and data directories.
- Full status view with server usage and per-process Psiphon CPU/RAM.
- Firewall / open-port checker for UFW and firewalld.
- Per-location latency and download speed tests through each SOCKS proxy.
- Optional `systemd` autostart at boot.
- English and Persian documentation.

[2.1.0]: https://github.com/IzumiRain/xPsiphon
[2.0.0]: https://github.com/IzumiRain/xPsiphon
[1.0.0]: https://github.com/IzumiRain/xPsiphon
