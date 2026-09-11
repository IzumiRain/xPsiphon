<div align="center">

# 🌧️ xPsiphon

### A simple terminal panel for running multiple Psiphon locations on one Linux server

**English** · [فارسی](README.fa.md)

<br>

[![Version](https://img.shields.io/badge/version-2.1.0-2ea043?style=flat-square)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Ubuntu%20%2F%20Linux-e95420?style=flat-square)](#-step-1--get-a-server)
[![Dependencies](https://img.shields.io/badge/python-3.8%2B%20(no%20pip%20deps)-ffd343?style=flat-square)](#)
[![Locations](https://img.shields.io/badge/locations-AUTO%20%2B%2028%20countries-8957e5?style=flat-square)](#-locations--ports)

</div>

---

## 💡 What is xPsiphon?

**xPsiphon turns one Linux server into a set of Psiphon proxies you can control from a single, simple menu.**

Psiphon is a free tool that tunnels your traffic out through servers around the
world. xPsiphon runs **one Psiphon tunnel per country** on your own server — all
at the same time, each on its own port — and gives you a simple panel to start,
stop, watch, and test them.

You do **not** need to be an expert. If you can copy and paste one command, you
can install it. Every step below is written for a first-timer.

## 📑 Table of Contents

**Start here (step by step)**
- [Step 1 — Get a server](#%EF%B8%8F-step-1--get-a-server)
- [Step 2 — Install xPsiphon](#-step-2--install-xpsiphon)
- [Step 3 — Start a location](#%EF%B8%8F-step-3--start-a-location)

**Everyday use**
- [The menu (interactive panel)](#%EF%B8%8F-the-menu-interactive-panel)
- [Command cheat-sheet](#%EF%B8%8F-command-cheat-sheet)
- [Locations & ports](#-locations--ports)
- [Change a location's port](#-change-a-locations-port)
- [Logs](#-logs)
- [Firewall & open ports](#-firewall--open-ports)
- [Ping & speed tests](#-ping--speed-tests)
- [Start on boot (autostart)](#-start-on-boot-autostart)

**Integrations**
- [HTTP API](#-http-api)

**Maintenance**
- [Update](#%EF%B8%8F-update)
- [Uninstall](#%EF%B8%8F-uninstall)
- [Paths](#%EF%B8%8F-paths)
- [Troubleshooting](#-troubleshooting)

**Security**
- [Security model](#-security-model)
- [Reporting a vulnerability](#-reporting-a-vulnerability)

**About**
- [Features](#-features)
- [Credits](#-credits) · [Donate](#-donate) · [License](#-license)

---

## 🖥️ Step 1 — Get a server

You need a small Linux server (a "VPS"). Almost any cheap one works.

- **Operating system:** any recent Linux with `systemd`. Ubuntu 22/24 and Debian
  are the most tested; the installer also detects and uses the native package
  manager on Fedora, RHEL 8+, AlmaLinux, Rocky Linux, CentOS 7, openSUSE, Arch
  Linux, Manjaro, and Alpine. **x86_64 only** — the Psiphon core binaries are
  built for x86_64 upstream.
- **Python:** 3.8 or newer. The installer checks the real version, and on
  distributions that still ship an older `python3` (RHEL/AlmaLinux 8, openSUSE
  Leap 15, CentOS 7) it installs a newer one (`python39` / `python311`) and
  exposes it as `python3`.
- **Size:** the smallest plan is enough (1 CPU / 512 MB RAM works).
- **Access:** you log in as `root` (or a user with `sudo`).

> **Alpine note:** the installer is a bash script and Alpine ships `ash` with no
> bash, so bash must exist before the one-liner can run:
>
> ```bash
> apk add --no-cache bash curl
> ```
>
> after that, the standard one-liner works (the installer also installs `procps`
> so the process table is complete).

```bash
ssh root@YOUR_SERVER_IP
```

Once you see the server's command prompt, continue to Step 2.

## 📥 Step 2 — Install xPsiphon

Copy this line, paste it into your server, and press Enter:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

That's it. The installer does everything for you:

- ✅ installs `curl`, `ca-certificates`, and `python3` if they are missing
- ✅ downloads the Psiphon core engine
- ✅ installs the `xpsiphon` command **and** the short `xp` alias
- ✅ creates all the location configs (`AUTO` + 28 countries)
- ✅ sets up the log, data, and run folders

When it finishes, check that it worked:

```bash
xp version      # should print: xPsiphon 2.0.0
xp doctor       # should show green OK lines
```

> 💡 **Want it to auto-start on every reboot?** Add `--enable-autostart` to the
> install command, or set it up later with `sudo xp autostart on`.

## ▶️ Step 3 — Start a location

The easiest choice is `AUTO`, which lets Psiphon pick the best server for you:

```bash
sudo xp start AUTO
```

Check that it is running:

```bash
xp status
```

Want a specific country instead? Use its two-letter code (see the
[full list](#-locations--ports)):

```bash
sudo xp start US      # United States
sudo xp start DE      # Germany
sudo xp start all     # start every location at once
```

Each location listens on its **own local ports**. For example:

```text
AUTO  →  SOCKS 127.0.0.1:1080   |  HTTP 127.0.0.1:8080
US    →  SOCKS 127.0.0.1:1101   |  HTTP 127.0.0.1:8101
```

## 🎛️ The menu (interactive panel)

Prefer a menu over typing commands? Just run:

```bash
xp
```

You'll get a panel where you can, with a single keypress:

- 📊 see full status
- ▶️ start `AUTO`, or start / stop / restart a chosen location
- ⏯️ start all / stop all
- 📜 tail a location's logs
- 🔁 toggle autostart
- 🔌 manage the HTTP API server (status / start / stop)
- 🔧 change a location's SOCKS/HTTP port
- 🧱 run the firewall / open-port check
- 📶 run ping / speed tests
- 🩺 run doctor checks
- ⬆️ update xPsiphon
- 🗑️ uninstall xPsiphon

`xpsiphon` and `xp` are the same command — use whichever you like.

## ⌨️ Command cheat-sheet

| Command | What it does |
| --- | --- |
| `xp` | Open the interactive menu |
| `xp status` | Show server status and every Psiphon instance |
| `xp locations` | List locations, ports, and config paths |
| `sudo xp start AUTO` | Start the automatic location |
| `sudo xp start US` | Start one country |
| `sudo xp start all` | Start every location |
| `sudo xp stop US` | Stop one location |
| `sudo xp stop all` | Stop every location |
| `sudo xp restart US` | Restart one location |
| `xp logs US` | Show the latest log lines for a location |
| `xp logs US -f` | Follow a location's log live |
| `sudo xp port US --socks 1201 --http 8201` | Change a location's ports |
| `xp firewall` | Check local ports + UFW/firewalld |
| `xp ports` | Alias for `xp firewall` |
| `xp test` | Test all running locations |
| `xp test AUTO` | Test one location |
| `xp speed US` | Alias for `xp test US` |
| `xp doctor` | Check prerequisites and install health |
| `sudo xp autostart on` / `off` | Enable / disable start-on-boot |
| `xp autostart status` | Show autostart status |
| `sudo xp api start` | Install and start the HTTP API service |
| `xp api status` | Show API state, URL, and a test command |
| `xp api serve` | Run the API in the foreground (no systemd) |
| `sudo xp api stop` | Stop and remove the API service |
| `sudo xp update` | Update in place (keeps configs & running tunnels) |
| `sudo xp uninstall` | Remove xPsiphon (keeps configs & binary) |
| `sudo xp uninstall --purge` | Remove **everything** |
| `xp version` | Show the installed version |

> 🔐 Actions that start/stop things or change the system need `sudo`. Read-only
> actions (`status`, `locations`, `logs`, `test`, `doctor`) do not.

## 🌍 Locations & ports

`AUTO` uses Psiphon's automatic server selection:

```text
AUTO SOCKS: 127.0.0.1:1080     AUTO HTTP: 127.0.0.1:8080
```

Each country runs on its own **unique, fixed** ports so they can all run
together:

```text
AT SOCKS 1081 / HTTP 8081     JP SOCKS 1095 / HTTP 8095
BE SOCKS 1082 / HTTP 8082     NL SOCKS 1096 / HTTP 8096
BG SOCKS 1083 / HTTP 8083     NO SOCKS 1097 / HTTP 8097
CA SOCKS 1084 / HTTP 8084     PL SOCKS 1098 / HTTP 8098
CH SOCKS 1085 / HTTP 8085     RO SOCKS 1099 / HTTP 8099
CZ SOCKS 1086 / HTTP 8086     SE SOCKS 1100 / HTTP 8100
DE SOCKS 1087 / HTTP 8087     US SOCKS 1101 / HTTP 8101
DK SOCKS 1088 / HTTP 8088     AU SOCKS 1102 / HTTP 8102
EE SOCKS 1089 / HTTP 8089     ES SOCKS 1103 / HTTP 8103
FI SOCKS 1090 / HTTP 8090     ID SOCKS 1104 / HTTP 8104
FR SOCKS 1091 / HTTP 8091     IE SOCKS 1105 / HTTP 8105
GB SOCKS 1092 / HTTP 8092     LT SOCKS 1106 / HTTP 8106
IN SOCKS 1093 / HTTP 8093     RS SOCKS 1107 / HTTP 8107
IT SOCKS 1094 / HTTP 8094     SG SOCKS 1108 / HTTP 8108
```

The country list (**28 egress regions**) was verified against the **live Psiphon
client** — the `AvailableEgressRegions` set reported by `psiphon-tunnel-core` on
the same propagation channel these configs use.

> 🧩 **Legacy regions:** `BG` (Bulgaria) and `EE` (Estonia) are kept for backward
> compatibility but were **not** in the current live region set. They're harmless
> if unused — a fixed region with no available server just won't connect. To
> remove them, delete `/etc/psiphon/configs/psiphon.BG.config` and
> `/etc/psiphon/configs/psiphon.EE.config`.

> 🔒 **Ports are stable across updates.** New locations always take the next free
> port instead of renumbering existing ones, so your firewall rules keep working.

## 🔧 Change a location's port

Each location's ports live in its own config file. If a default port is already
taken on your server (say something else uses `1092`), reassign it:

```bash
sudo xp port GB --socks 1201 --http 8201
sudo xp port GB --socks 1201          # change SOCKS only, keep HTTP
```

You can also do this from the panel with `p) Change location port`. xPsiphon
rejects ports that clash with another location or fall out of range. If the
location is running, restart it to apply the change:

```bash
sudo xp restart GB
```

## 📜 Logs

Every location writes its own log file:

```text
/var/log/xpsiphon/psiphon.AUTO.log
/var/log/xpsiphon/psiphon.US.log
```

View them:

```bash
xp logs AUTO       # last lines
xp logs US -f      # follow live (Ctrl-C to stop)
```

## 🧱 Firewall & open ports

Check which ports are listening and what your firewall allows:

```bash
xp firewall
```

It reports:

- whether each SOCKS/HTTP port is free or listening
- UFW status and matching allow rules
- firewalld status and matching allowed ports

## 📶 Ping & speed tests

Test running locations through their SOCKS proxy:

```bash
xp test           # test all running locations
xp test AUTO      # test one
xp speed US       # alias for: xp test US
```

Only **running** locations can be tested. A stopped one shows `not listening`.

Options:

```bash
xp test AUTO --no-speed
xp test US --timeout 30
xp test AUTO --url https://www.gstatic.com/generate_204
xp test AUTO --speed-url https://speed.cloudflare.com/__down?bytes=1048576
```

> ℹ️ The "ping" value is HTTPS request latency **through the proxy**, not ICMP
> ping.

## 🔁 Start on boot (autostart)

xPsiphon starts every configured location automatically when the server reboots:

```bash
sudo xp autostart on       # enable
sudo xp autostart off      # disable
xp autostart status        # check
systemctl status xpsiphon.service
```

## 🔌 HTTP API

Everything the panel does is also available over a small JSON HTTP API, so you
can drive xPsiphon from a script, a dashboard, or another app. It uses only the
Python standard library — no extra dependencies.

### Start it

```bash
sudo xp api start          # install + start as a systemd service (recommended)
xp api status              # show state, URL, and the test command
sudo xp api restart        # restart the service
sudo xp api stop           # stop and remove the service
xp api serve               # run in the foreground (Ctrl-C to stop, no systemd)
```

By default the API listens on **`127.0.0.1:8900`** — loopback only, so it is not
reachable from the internet. Change that with `--host` / `--port`:

```bash
sudo xp api start --host 127.0.0.1 --port 9000
```

> ⚠️ Binding to a public address (`--host 0.0.0.0`) exposes the API to the
> network. Only do this together with a firewall rule limited to trusted IPs,
> and treat the token as a password.

### Authentication

Every request needs the token. It is generated on first use and stored in
`/etc/psiphon/api-token` with `0600` permissions. Send it as a header — there
is deliberately **no query-parameter form**, because a token in the URL is
world-readable in `/proc/<pid>/cmdline` and persists in shell history:

```bash
TOKEN=$(sudo cat /etc/psiphon/api-token)

curl -s -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8900/api/status
curl -s -H "X-Api-Token: $TOKEN"          http://127.0.0.1:8900/api/status
```

Requests without a valid token get `401`, and repeated failures from the same
address are throttled with `429`. Set `XPSIPHON_API_TOKEN` in the
environment to override the token file (useful for rotation without touching
disk) — the environment value always wins.

### Endpoints

| Method | Endpoint | What it does |
| --- | --- | --- |
| `GET` | `/` | List every endpoint |
| `GET` | `/api/version` | Version and update source |
| `GET` | `/api/status` | Full server + per-location status |
| `GET` | `/api/locations` | Configured locations, ports, config paths |
| `GET` | `/api/logs/{LOC}?lines=100` | Tail one location's log (`lines` max 2000) |
| `GET` | `/api/autostart` | autostart state |
| `GET` | `/api/doctor` | Run the doctor checks |
| `POST` | `/api/start/{LOC\|all}` | Start locations |
| `POST` | `/api/stop/{LOC\|all}` | Stop locations |
| `POST` | `/api/restart/{LOC\|all}` | Restart locations |
| `POST` | `/api/test/{LOC\|all}?timeout=20&no_speed=1` | Latency / speed test through SOCKS |
| `POST` | `/api/autostart/{on\|off\|toggle}` | Change autostart |
| `POST` | `/api/port/{LOC}` | Change ports: `{"socks": 1201, "http": 8201}` |

`{LOC}` is a location code (`AUTO`, `US`, `DE`, …). Endpoints that change the
system (`start`, `stop`, `restart`, `autostart`, `port`) need the service to run
as root and return `403` otherwise — when you install it with `sudo xp api
start` that is already the case.

### Example

```bash
TOKEN=$(sudo cat /etc/psiphon/api-token)
BASE=http://127.0.0.1:8900

# what is running right now?
curl -s -H "Authorization: Bearer $TOKEN" "$BASE/api/status" | python3 -m json.tool

# start every location
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$BASE/api/start/all"

# move US to new ports
curl -s -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" -d '{"socks":1201,"http":8201}' \
  "$BASE/api/port/US"

# last 50 log lines for AUTO
curl -s -H "Authorization: Bearer $TOKEN" "$BASE/api/logs/AUTO?lines=50"
```

Useful environment overrides for the API:

```bash
XPSIPHON_API_HOST=127.0.0.1        # bind address
XPSIPHON_API_PORT=8900             # port
XPSIPHON_API_TOKEN_FILE=/etc/psiphon/api-token
XPSIPHON_API_TOKEN=...             # token override (wins over the file)
```

## ⬆️ Update

Update an existing install to the latest version:

```bash
sudo xp update
```

**Updates are non-disruptive by design** — a running server keeps working:

- ✅ your existing configs are kept, **including custom ports**
- ✅ the Psiphon core binary is kept as-is (not re-downloaded)
- ✅ running tunnels are **not** stopped; autostart is **not** changed
- ✅ only **new** location configs are added

New locations are added but not started automatically. Start them when ready:

```bash
sudo xp start all
```

Optional, opt-in refreshes (these *can* be disruptive):

```bash
sudo xp update --force-psiphon    # also re-download the core binary
sudo xp update --force-configs    # overwrite configs (RESETS custom ports)
```

You can also update from the panel (`u) Update xPsiphon`) or by re-running the
one-line installer — it behaves the same safe way.

> 📝 `xp update` pulls from GitHub `main`. See the
> [CHANGELOG](CHANGELOG.md) for what changed between versions.

## 🗑️ Uninstall

Remove xPsiphon with one command:

```bash
sudo xp uninstall
```

This stops all locations, disables and removes the `xpsiphon.service`, removes
the `xpsiphon` and `xp` commands, and removes the runtime directories
(`/run/xpsiphon`, `/var/log/xpsiphon`, `/tmp/psiphon`). Your configs and the
Psiphon binary in `/etc/psiphon` are **kept** by default.

Remove **everything**, including configs and the binary:

```bash
sudo xp uninstall --purge
```

Skip the confirmation prompt (for scripts):

```bash
sudo xp uninstall --yes
sudo xp uninstall --purge --yes
```

You can also uninstall from the panel (`x) Uninstall xPsiphon`).

<details>
<summary>Manual cleanup (if the <code>xp</code> command is already gone)</summary>

```bash
sudo systemctl disable --now xpsiphon.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/xpsiphon.service
sudo systemctl daemon-reload 2>/dev/null || true
sudo rm -f /usr/local/bin/xpsiphon /usr/local/bin/xp
sudo rm -rf /run/xpsiphon /var/log/xpsiphon /tmp/psiphon
sudo rm -rf /etc/psiphon   # only if you also want to delete configs and the binary
```

</details>

## 🗂️ Paths

Default paths:

```text
Psiphon binary: /etc/psiphon/psiphon-tunnel-core-x86_64
Configs:        /etc/psiphon/configs
Data roots:     /tmp/psiphon
Logs:           /var/log/xpsiphon
PID files:      /run/xpsiphon
Systemd unit:   /etc/systemd/system/xpsiphon.service
API unit:       /etc/systemd/system/xpsiphon-api.service
API token:      /etc/psiphon/api-token
```

Runtime overrides (environment variables):

```bash
XPSIPHON_BIN=/path/to/psiphon-tunnel-core-x86_64
XPSIPHON_CONF_DIR=/path/to/configs
XPSIPHON_DATA_DIR=/path/to/data
XPSIPHON_LOG_DIR=/path/to/logs
XPSIPHON_RUN_DIR=/path/to/run
XPSIPHON_SERVICE_PATH=/etc/systemd/system/xpsiphon.service
XPSIPHON_API_SERVICE_PATH=/etc/systemd/system/xpsiphon-api.service
XPSIPHON_API_TOKEN_FILE=/etc/psiphon/api-token
```

Optional Go runtime tuning for the tunnel processes (**off by default**):

```bash
XPSIPHON_GOGC=50                 # GC target percentage (default: Go's own value)
XPSIPHON_GOMEMLIMIT=45MiB        # soft memory limit per tunnel process
```

These are opt-in on purpose. The Go runtime defaults are a safe baseline;
lowering `GOGC` or setting a tight `GOMEMLIMIT` trades **more CPU** for a smaller
resident set, which can hurt a small or single-core server. Set `XPSIPHON_*` in
the environment before starting, or add them to the systemd unit, then
`sudo xp restart all`. If set, they are also written into the autostart unit so
reboots behave the same as manual starts. An explicit `XPSIPHON_*` value always
wins over an inherited `GOGC`/`GOMEMLIMIT`.

Installer overrides:

```bash
XPSIPHON_INSTALL_PATH=/usr/local/bin/xpsiphon
XPSIPHON_SHORT_PATH=/usr/local/bin/xp
XPSIPHON_GITHUB_REPO=IzumiRain/xPsiphon
XPSIPHON_GITHUB_REF=main
```

## 🔐 Security model

xPsiphon runs **as root** (starting and stopping tunnels requires it), so the
security design is built around protecting that surface. The short version —
full details in [SECURITY.md](SECURITY.md):

- **The HTTP API is the only network-facing surface**, and it listens on
  `127.0.0.1` by default. Every request needs the token (headers only — the
  URL query form was deliberately removed because tokens in URLs are readable
  via `/proc/<pid>/cmdline`); repeated failures from one address are throttled
  with `429`.
- **The API token is a root-equivalent secret.** It is generated with 192 bits
  of entropy, stored `0600`, and comparing it is constant-time. Treat it like
  a password; rotate it by deleting the token file or setting
  `XPSIPHON_API_TOKEN`.
- **systemd sandboxing** is applied to both units (`ProtectSystem=strict`,
  `NoNewPrivileges`, `MemoryDenyWriteExecute`, bounded `ReadWritePaths`), so a
  bug in the manager or the tunnel does not automatically mean the whole
  filesystem is writable. Tunnels still connect normally under the sandbox.
- **Runtime directories are validated** — the manager refuses to use a data
  directory that someone else pre-created in `/tmp` (a known local-attack
  pattern against root services).
- **Downloads are sanity-checked** before being executed as root (size +
  ELF/x86-64 header). The bootstrap still fetches code over TLS from GitHub;
  pin `XPSIPHON_GITHUB_REF` to a tag if you want a frozen supply chain.

> 🔎 Found a security bug? See [Reporting a vulnerability](#-reporting-a-vulnerability)
> — please do not open a public issue.

## 🚨 Reporting a vulnerability

Please report security issues **privately**, via GitHub's
[private vulnerability reporting](https://github.com/IzumiRain/xPsiphon/security/advisories/new)
on this repository.

Please include: the affected version (`xp version`), the distribution, what
you did, what you expected, and — if possible — a minimal reproduction. You
will get an acknowledgement within a few days, and credit in the changelog
unless you prefer to stay anonymous.

Please **do not** open a public issue for anything you believe is
exploitable, and do not test against servers you do not own.

## 🩹 Troubleshooting

<details>
<summary><code>Psiphon binary not found</code></summary>

Run the bootstrap installer again:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

</details>

<details>
<summary><code>not listening</code> in a speed test</summary>

Start the location first, then test it:

```bash
sudo xp start AUTO
xp test AUTO
```

</details>

<details>
<summary>Permission errors</summary>

Starting, stopping, restarting, and autostart need root:

```bash
sudo xp start AUTO
sudo xp stop all
```

</details>

<details>
<summary>Check overall health</summary>

```bash
xp doctor
xp status
  xp locations
  ```

</details>

<details>
<summary>API returns <code>401</code> or <code>403</code></summary>

`401` means the token is missing or wrong — send it as shown in
[HTTP API](#-http-api). `403` means the endpoint needs root: install the API as
a service with `sudo xp api start`, or run `sudo xp api serve`.

To check it is up, and to read the token:

```bash
xp api status
sudo cat /etc/psiphon/api-token
```

</details>


## ✨ Features

- One-line install on a fresh Ubuntu server
- Multi-distribution installer (apt, dnf, yum, zypper, pacman, apk)
- Interactive terminal panel
- Short command alias: `xp`
- `AUTO` location on SOCKS `1080` / HTTP `8080`
- **28** country locations on unique ports (verified against the live client)
- Customizable per-location SOCKS/HTTP ports (CLI or panel)
- Start / stop / restart one location or all locations
- Full status view with server usage and per-process Psiphon CPU/RAM
- Separate log file per location
- Firewall / open-port checker for UFW and firewalld
- Per-location ping and download speed tests through SOCKS
- Safe, non-disruptive in-place updates
- Clean uninstall (with optional purge)
- Optional `systemd` autostart
- **JSON HTTP API** with token auth, for programmatic control
- **No Python package dependencies**

## 🙌 Credits

- xPsiphon management panel — [IzumiRain](https://github.com/IzumiRain)
- Psiphon tunnel core binary — [Psiphon-Labs](https://github.com/Psiphon-Labs)
- Psiphon Linux reference project — [SpherionOS/PsiphonLinux](https://github.com/SpherionOS/PsiphonLinux)

## 💖 Donate

If xPsiphon is useful to you, donations are appreciated 🙏

| Network | Address |
| --- | --- |
| **TRC20** (Tron) | `TKBHWNoeygcaCK8N78e7dQX5Yco3WTb6ZN` |
| **BEP20** (BNB Smart Chain) | `0x0F982640a69D3B9FB944840D7DA8bECCfcF0bb9E` |
| **TON** | `UQAyLUyxew-eggwhxbzsAZZZ9ULM8MYOk-3IXFh7tNC33LNt` |

## 📄 License

[MIT](LICENSE) © IzumiRain

<div align="center">

<sub>

Made with ❤️ by <a href="https://github.com/IzumiRain">IzumiRain</a><br>

<a href="README.fa.md">فارسی</a> · <a href="CHANGELOG.md">Changelog</a>

</sub>
</div>
