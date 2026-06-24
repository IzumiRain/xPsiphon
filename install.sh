#!/usr/bin/env bash
set -euo pipefail

APP_NAME="xpsiphon"
SHORT_NAME="xp"
GITHUB_REPO="${XPSIPHON_GITHUB_REPO:-IzumiRain/xPsiphon}"
GITHUB_REF="${XPSIPHON_GITHUB_REF:-main}"
RAW_BASE="https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_REF}"
INSTALLER_URL="${RAW_BASE}/install.sh"
APP_URL="${RAW_BASE}/${APP_NAME}"
PSIPHON_CORE_URL="https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core-binaries/master/linux/psiphon-tunnel-core-x86_64"

INSTALL_PATH="${XPSIPHON_INSTALL_PATH:-/usr/local/bin/${APP_NAME}}"
SHORT_PATH="${XPSIPHON_SHORT_PATH:-/usr/local/bin/${SHORT_NAME}}"
PSIPHON_DIR="${XPSIPHON_PSIPHON_DIR:-/etc/psiphon}"
PSIPHON_BIN="${XPSIPHON_BIN:-${PSIPHON_DIR}/psiphon-tunnel-core-x86_64}"
CONFIG_DIR="${XPSIPHON_CONF_DIR:-${PSIPHON_DIR}/configs}"
DATA_DIR="${XPSIPHON_DATA_DIR:-/tmp/psiphon}"
LOG_DIR="${XPSIPHON_LOG_DIR:-/var/log/xpsiphon}"
RUN_DIR="${XPSIPHON_RUN_DIR:-/run/xpsiphon}"

copy_configs=1
force_configs=0
install_psiphon=1
force_psiphon=0
enable_autostart=0
original_args=("$@")

banner() {
  local width=61
  local line="═════════════════════════════════════════════════════════════"
  local text pad left right
  printf '# %s\n' "${line}"
  for text in \
    "xPsiphon Installer - By IzumiRain" \
    "Psiphon core + AUTO/country configs + terminal panel" \
    "https://github.com/IzumiRain/xPsiphon"
  do
    pad=$((width - ${#text}))
    if (( pad < 0 )); then
      printf '# %s\n' "${text}"
    else
      left=$((pad / 2))
      right=$((pad - left))
      printf '# %*s%s%*s\n' "${left}" "" "${text}" "${right}" ""
    fi
  done
  printf '# %s\n' "${line}"
}

usage() {
  banner
  cat <<USAGE
xPsiphon bootstrap installer

Usage:
  bash <(curl -fsSL ${INSTALLER_URL}) [options]
  sudo bash install.sh [options]

Options:
  --no-configs        Do not generate configs in ${CONFIG_DIR}
  --force-configs     Overwrite existing generated configs
  --skip-psiphon      Do not install/download the Psiphon core binary
  --force-psiphon     Re-download the Psiphon core binary even if it exists
  --enable-autostart  Enable xpsiphon.service after install
  -h, --help          Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-configs)
      copy_configs=0
      ;;
    --force-configs)
      force_configs=1
      ;;
    --skip-psiphon)
      install_psiphon=0
      ;;
    --force-psiphon)
      force_psiphon=1
      ;;
    --enable-autostart)
      enable_autostart=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ "${EUID}" -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    echo "[xPsiphon] Root privileges are required. Re-running installer with sudo..."
    tmp_installer="$(mktemp)"
    if [[ -f "${BASH_SOURCE[0]}" && "${BASH_SOURCE[0]}" != /dev/fd/* ]]; then
      cp "${BASH_SOURCE[0]}" "${tmp_installer}"
    else
      curl -fsSL "${INSTALLER_URL}" -o "${tmp_installer}"
    fi
    exec sudo bash "${tmp_installer}" "${original_args[@]}"
  fi
  echo "This installer must run as root. Re-run with sudo or as root." >&2
  exit 1
fi

banner

log() {
  printf '\033[1;36m[xPsiphon]\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33m[xPsiphon]\033[0m %s\n' "$*"
}

fail() {
  printf '\033[1;31m[xPsiphon]\033[0m %s\n' "$*" >&2
  exit 1
}

need_command() {
  command -v "$1" >/dev/null 2>&1
}

install_packages() {
  local packages=()
  need_command curl || packages+=("curl")
  need_command python3 || packages+=("python3")
  need_command install || packages+=("coreutils")
  need_command systemctl || true

  if [[ "${#packages[@]}" -eq 0 ]]; then
    return
  fi

  if ! need_command apt-get; then
    fail "Missing required commands: ${packages[*]}. Install them manually and re-run."
  fi

  log "Installing prerequisites: ${packages[*]}"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ca-certificates "${packages[@]}"
}

download_file() {
  local url="$1"
  local destination="$2"
  local mode="$3"
  local tmp
  tmp="$(mktemp)"
  curl -fL --retry 3 --connect-timeout 20 "${url}" -o "${tmp}"
  install -m "${mode}" "${tmp}" "${destination}"
  rm -f "${tmp}"
}

install_manager() {
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || pwd)"
  local source_app="${script_dir}/${APP_NAME}"

  mkdir -p "$(dirname -- "${INSTALL_PATH}")" "$(dirname -- "${SHORT_PATH}")"

  if [[ -f "${source_app}" ]]; then
    log "Installing manager from local file: ${source_app}"
    python3 -m py_compile "${source_app}"
    install -m 0755 "${source_app}" "${INSTALL_PATH}"
  else
    log "Downloading manager from ${APP_URL}"
    local tmp_app
    tmp_app="$(mktemp)"
    curl -fL --retry 3 --connect-timeout 20 "${APP_URL}" -o "${tmp_app}"
    python3 -m py_compile "${tmp_app}"
    install -m 0755 "${tmp_app}" "${INSTALL_PATH}"
    rm -f "${tmp_app}"
  fi

  ln -sfn "${INSTALL_PATH}" "${SHORT_PATH}"
  log "Installed shortcut: ${SHORT_PATH} -> ${INSTALL_PATH}"
}

install_psiphon_binary() {
  mkdir -p "${PSIPHON_DIR}" "$(dirname -- "${PSIPHON_BIN}")"
  if [[ "${install_psiphon}" -ne 1 ]]; then
    warn "Skipping Psiphon core binary install by request."
    return
  fi

  if [[ -x "${PSIPHON_BIN}" && "${force_psiphon}" -ne 1 ]]; then
    log "Psiphon core binary already exists: ${PSIPHON_BIN}"
    return
  fi

  log "Downloading Psiphon core binary"
  download_file "${PSIPHON_CORE_URL}" "${PSIPHON_BIN}" "0755"
}

generate_configs() {
  if [[ "${copy_configs}" -ne 1 ]]; then
    warn "Skipping config generation by request."
    return
  fi

  mkdir -p "${CONFIG_DIR}"
  log "Generating Psiphon configs in ${CONFIG_DIR}"

  FORCE_CONFIGS="${force_configs}" CONFIG_DIR="${CONFIG_DIR}" python3 - <<'PY'
import json
import os
from pathlib import Path

config_dir = Path(os.environ["CONFIG_DIR"])
force = os.environ.get("FORCE_CONFIGS") == "1"

public_key = (
    "MIICIDANBgkqhkiG9w0BAQEFAAOCAg0AMIICCAKCAgEAt7Ls+/39r+T6zNW7GiVpJfzq/"
    "xvL9SBH5rIFnk0RXYEYavax3WS6HOD35eTAqn8AniOwiH+DOkvgSKF2caqk/y1dfq47Pdym"
    "twzp9ikpB1C5OfAysXzBiwVJlCdajBKvBZDerV1cMvRzCKvKwRmvDmHgphQQ7WfXIGbRbmm"
    "k6opMBh3roE42KcotLFtqp0RRwLtcBRNtCdsrVsjiI1Lqz/lH+T61sGjSjQ3CHMuZYSQJZo/"
    "KrvzgQXpkaCTdbObxHqb6/+i1qaVOfEsvjoiyzTxJADvSytVtcTjijhPEV6XskJVHE1Zgl+7"
    "rATr/pDQkw6DPCNBS1+Y6fy7GstZALQXwEDN/qhQI9kWkHijT8ns+i1vGg00Mk/6J75arLhqc"
    "odWsdeG/M/moWgqQAnlZAGVtJI1OgeF5fsPpXu4kctOfuZlGjVZXQNW34aOzm8r8S0eVZitPl"
    "bhcPiR4gT/aSMz/wd8lZlzZYsje/Jr8u/YtlwjjreZrGRmG8KMOzukV3lLmMppXFMvl4bxv6Y"
    "FEmIuTsOhbLTwFgh7KYNjodLj/LsqRVfwz31PgWQFTEPICV7GCvgVlPRxnofqKSjgTWI4mxDh"
    "BpVcATvaoBl1L/6WLbFvBsoAUBItWwctO2xalKxF5szhGm8lccoc5MZr8kfE0uxMgsxz4er68"
    "iCID+rsCAQM="
)

base = {
    "PropagationChannelId": "FFFFFFFFFFFFFFFF",
    "RemoteServerListDownloadFilename": "remote_server_list",
    "RemoteServerListSignaturePublicKey": public_key,
    "RemoteServerListUrl": "https://s3.amazonaws.com//psiphon/web/mjr4-p23r-puwl/server_list_compressed",
    "SponsorId": "FFFFFFFFFFFFFFFF",
    "UseIndistinguishableTLS": True,
}

locations = [
    "AUTO",
    "AT", "BE", "BG", "CA", "CH", "CZ", "DE", "DK", "EE", "FI",
    "FR", "GB", "IN", "IT", "JP", "NL", "NO", "PL", "RO", "SE", "US",
]

for index, code in enumerate(locations):
    data = dict(base)
    data["LocalHttpProxyPort"] = 8080 + index
    data["LocalSocksProxyPort"] = 1080 + index
    if code != "AUTO":
        data["EgressRegion"] = code

    path = config_dir / f"psiphon.{code}.config"
    if path.exists() and not force:
        print(f"Keeping existing {path}")
        continue

    path.write_text(json.dumps(data, indent=2, sort_keys=False) + "\n", encoding="utf-8")
    print(f"Wrote {path}")
PY
}

create_dirs() {
  mkdir -p "${DATA_DIR}" "${LOG_DIR}" "${RUN_DIR}"
}

enable_service_if_requested() {
  if [[ "${enable_autostart}" -ne 1 ]]; then
    return
  fi
  if ! need_command systemctl; then
    warn "systemctl not available; cannot enable autostart."
    return
  fi
  log "Enabling autostart"
  "${INSTALL_PATH}" autostart on
}

post_install_checks() {
  local failures=0

  [[ -x "${INSTALL_PATH}" ]] || { echo "Missing executable: ${INSTALL_PATH}" >&2; failures=$((failures + 1)); }
  [[ -x "${SHORT_PATH}" ]] || { echo "Missing shortcut: ${SHORT_PATH}" >&2; failures=$((failures + 1)); }
  if [[ "${install_psiphon}" -eq 1 ]]; then
    [[ -x "${PSIPHON_BIN}" ]] || { echo "Missing executable: ${PSIPHON_BIN}" >&2; failures=$((failures + 1)); }
  fi
  [[ -d "${CONFIG_DIR}" ]] || { echo "Missing config directory: ${CONFIG_DIR}" >&2; failures=$((failures + 1)); }
  [[ -f "${CONFIG_DIR}/psiphon.AUTO.config" ]] || { echo "Missing AUTO config" >&2; failures=$((failures + 1)); }

  if [[ "${failures}" -ne 0 ]]; then
    fail "Install checks failed."
  fi
}

install_packages
install_manager
install_psiphon_binary
create_dirs
generate_configs
post_install_checks
enable_service_if_requested

cat <<EOF

$(printf '\033[1;32m[xPsiphon]\033[0m') Installation complete.

Run:
  xpsiphon
  xp

Useful commands:
  xpsiphon doctor
  xp locations
  xpsiphon locations
  sudo xpsiphon start AUTO
  sudo xp start AUTO
  sudo xpsiphon start all

Ports:
  AUTO SOCKS: 127.0.0.1:1080
  AUTO HTTP:  127.0.0.1:8080
EOF
