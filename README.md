# xPsiphon

English | [فارسی](README.fa.md)

xPsiphon is a terminal management panel for running and monitoring multiple Psiphon locations on an Ubuntu server. It installs the Psiphon tunnel core, generates location configs, starts one Psiphon process per location, keeps separate logs, shows server/process usage, checks firewall ports, tests tunnel latency/speed, and can enable boot autostart through `systemd`.

The manager is a dependency-free Python 3 script. The bootstrap installer is Bash.


## Requirements

- Ubuntu 24 or another recent Linux server with `systemd`
- Root or sudo access
- `curl` for the one-line install command

The installer installs missing runtime dependencies such as `python3`, downloads the Psiphon core binary, generates configs, and installs both `xpsiphon` and `xp`.

## One-Line Install

Copy and run the following command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

The installer will:

- install `curl`, `ca-certificates`, and `python3` when needed
- download `psiphon-tunnel-core-x86_64`
- install `xpsiphon` to `/usr/local/bin/xpsiphon`
- install `xp` as `/usr/local/bin/xp`
- create `/etc/psiphon/configs`
- generate `AUTO` plus country configs
- create data, run, and log directories

Enable autostart during install:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh) --enable-autostart
```

## Features

- One-line install from a fresh Ubuntu server
- Interactive terminal panel with readable colored output
- Short command alias: `xp`
- AUTO location on SOCKS `1080` and HTTP `8080`
- Multi-location country configs on unique ports
- Start, stop, restart one location or all locations
- Full status view with server usage and Psiphon CPU/RAM
- Separate log file for each location
- Firewall/open-port checker for UFW and firewalld
- Per-location ping and download speed test through SOCKS
- Optional `systemd` autostart
- No Python package dependencies


## Local Install

From a cloned copy of this project:

```bash
sudo bash install.sh
```

Installer options:

```bash
sudo bash install.sh --force-configs
sudo bash install.sh --force-psiphon
sudo bash install.sh --enable-autostart
sudo bash install.sh --no-configs
sudo bash install.sh --skip-psiphon
```

## Quick Start

Open the panel:

```bash
xpsiphon
```

or:

```bash
xp
```

Start automatic location:

```bash
sudo xp start AUTO
```

Start all generated locations:

```bash
sudo xp start all
```

Check status:

```bash
xp status
```

Follow logs:

```bash
xp logs AUTO -f
```

## Command Reference

| Command | Description |
| --- | --- |
| `xp` | Open the interactive terminal panel |
| `xp status` | Show server status and all Psiphon instance status |
| `xp locations` | List discovered locations, ports, and config paths |
| `sudo xp start AUTO` | Start automatic Psiphon location |
| `sudo xp start US` | Start one fixed country location |
| `sudo xp start all` | Start every configured location |
| `sudo xp stop US` | Stop one location |
| `sudo xp stop all` | Stop every location |
| `sudo xp restart US` | Restart one location |
| `xp logs US` | Show latest log lines for one location |
| `xp logs US -f` | Follow one location log |
| `xp firewall` | Check local ports and UFW/firewalld state |
| `xp ports` | Alias for `xp firewall` |
| `xp test` | Test all running locations through SOCKS |
| `xp test AUTO` | Test one location |
| `xp speed US` | Alias for `xp test US` |
| `xp doctor` | Check prerequisites and installation state |
| `sudo xp autostart on` | Enable boot autostart |
| `sudo xp autostart off` | Disable boot autostart |
| `xp autostart status` | Show autostart status |

`xpsiphon` and `xp` are equivalent.

## Interactive Panel

Run:

```bash
xp
```

The panel includes:

- full status
- start AUTO
- start/stop/restart selected location
- start all / stop all
- tail logs
- toggle autostart
- firewall/open-port check
- ping/speed test
- doctor checks

## Ports And Locations

`AUTO` uses Psiphon's automatic server selection:

```text
AUTO SOCKS: 127.0.0.1:1080
AUTO HTTP:  127.0.0.1:8080
```

Country-specific configs use unique sequential ports so multiple locations can run at the same time:

```text
AT SOCKS 1081 / HTTP 8081
BE SOCKS 1082 / HTTP 8082
BG SOCKS 1083 / HTTP 8083
CA SOCKS 1084 / HTTP 8084
CH SOCKS 1085 / HTTP 8085
...
US SOCKS 1101 / HTTP 8101
```

Generated configs:

```text
/etc/psiphon/configs/psiphon.AUTO.config
/etc/psiphon/configs/psiphon.**.config
```

## Paths

Default paths:

```text
Psiphon binary: /etc/psiphon/psiphon-tunnel-core-x86_64
Configs:        /etc/psiphon/configs
Data roots:     /tmp/psiphon
Logs:           /var/log/xpsiphon
PID files:      /run/xpsiphon
Systemd unit:   /etc/systemd/system/xpsiphon.service
```

Runtime overrides:

```bash
XPSIPHON_BIN=/path/to/psiphon-tunnel-core-x86_64
XPSIPHON_CONF_DIR=/path/to/configs
XPSIPHON_DATA_DIR=/path/to/data
XPSIPHON_LOG_DIR=/path/to/logs
XPSIPHON_RUN_DIR=/path/to/run
XPSIPHON_SERVICE_PATH=/etc/systemd/system/xpsiphon.service
```

Installer overrides:

```bash
XPSIPHON_INSTALL_PATH=/usr/local/bin/xpsiphon
XPSIPHON_SHORT_PATH=/usr/local/bin/xp
XPSIPHON_GITHUB_REPO=IzumiRain/xPsiphon
XPSIPHON_GITHUB_REF=main
```

## Logs

Each location has a separate log:

```text
/var/log/xpsiphon/psiphon.AUTO.log
/var/log/xpsiphon/psiphon.**.log
```

View logs:

```bash
xp logs AUTO
xp logs US -f
```

## Firewall And Open Ports

Check local port state and common Linux firewall state:

```bash
xp firewall
```

The checker reports:

- whether each SOCKS/HTTP port is free or listening
- UFW status and matching allow rules
- firewalld status and matching allowed ports
- example commands for opening ports to trusted source IPs

Security note: expose proxy ports only to trusted IPs. Avoid opening proxy ports to the entire internet.

Example UFW rules for a trusted client IP:

```bash
sudo ufw allow from YOUR_IP to any port 1080:1101 proto tcp
sudo ufw allow from YOUR_IP to any port 8080:8101 proto tcp
```

## Ping And Speed Tests

Test running locations through their SOCKS proxy:

```bash
xp test
xp test AUTO
xp speed US
```

Only running locations can be tested. If a location is stopped, the result will be `not listening`.

Options:

```bash
xp test AUTO --no-speed
xp test US --timeout 30
xp test AUTO --url https://www.gstatic.com/generate_204
xp test AUTO --speed-url https://speed.cloudflare.com/__down?bytes=1048576
```

The ping value is HTTPS request latency through the proxy, not ICMP ping.

## Autostart

Enable xPsiphon at boot:

```bash
sudo xp autostart on
```

Disable:

```bash
sudo xp autostart off
```

Check:

```bash
xp autostart status
systemctl status xpsiphon.service
```

The service starts all configured locations at boot and stops them when the service is stopped.

## Update Or Reinstall

Re-run the installer:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

Force-refresh generated configs:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh) --force-configs
```

Force-refresh Psiphon core binary:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh) --force-psiphon
```

## Uninstall

```bash
sudo systemctl disable --now xpsiphon.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/xpsiphon.service
sudo systemctl daemon-reload 2>/dev/null || true
sudo rm -f /usr/local/bin/xpsiphon /usr/local/bin/xp
sudo rm -rf /run/xpsiphon /var/log/xpsiphon /tmp/psiphon
```

Configs and Psiphon binary are kept by default. Remove them only if you no longer need them:

```bash
sudo rm -rf /etc/psiphon
```

## Troubleshooting

### `Psiphon binary not found`

Run the bootstrap installer:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

### `not listening` in speed test

Start the location first:

```bash
sudo xp start AUTO
xp test AUTO
```

### Permission errors

Start/stop/restart/autostart actions need root:

```bash
sudo xp start AUTO
sudo xp stop all
```

### Check installation

```bash
xp doctor
xp status
xp locations
```

## Credits

- xPsiphon management panel: [IzumiRain](https://github.com/IzumiRain)
- Psiphon tunnel core binary: [Psiphon-Labs](https://github.com/Psiphon-Labs)
- Psiphon Linux reference project: [SpherionOS/PsiphonLinux](https://github.com/SpherionOS/PsiphonLinux)


##  Donate

If RainScanner is useful to you, donations are appreciated 🙏

| Network | Address |
|---------|---------|
| **TRC20** (Tron) | `TKBHWNoeygcaCK8N78e7dQX5Yco3WTb6ZN` |
| **BEP20** (BNB Smart Chain) | `0x0F982640a69D3B9FB944840D7DA8bECCfcF0bb9E` |
| **TON** | `UQAyLUyxew-eggwhxbzsAZZZ9ULM8MYOk-3IXFh7tNC33LNt` |


##  License

[MIT](LICENSE) © IzumiRain.
