# Changelog

All notable changes to **xPsiphon** are documented in this file.

[فارسی](CHANGELOG.fa.md) | English

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

[2.0.0]: https://github.com/IzumiRain/xPsiphon
[1.0.0]: https://github.com/IzumiRain/xPsiphon
