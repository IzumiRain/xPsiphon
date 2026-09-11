# Security Policy

## Supported versions

Only the latest release receives security fixes.

| Version | Supported |
| --- | --- |
| 2.1.0 | ✅ |
| < 2.1.0 | ❌ |

## Reporting a vulnerability

**Please do not open a public issue for a security problem.**

Report privately through GitHub's
[private vulnerability reporting](https://github.com/IzumiRain/xPsiphon/security/advisories/new)
on this repository.

Include:

- the affected version (`xp version`) and distribution (`cat /etc/os-release`);
- what you did and what happened;
- a minimal reproduction, if you have one;
- your assessment of impact, if you have one (we will verify independently).

You will receive an acknowledgement within a few days. Fixes are released as
soon as practical, and you will be credited in the changelog unless you prefer
to stay anonymous.

Please **do not** test against servers you do not own or have explicit
permission to test.

## Scope

### In scope

- `xpsiphon` — the manager, CLI, interactive panel and HTTP API (the only
  network-facing surface).
- `install.sh` — the bootstrap installer and the update path it drives.
- The generated `systemd` units (`xpsiphon.service`, `xpsiphon-api.service`).

### Out of scope

- `psiphon-tunnel-core` itself — it is an upstream binary from
  [Psiphon-Labs](https://github.com/Psiphon-Labs); report issues there.
- The anonymity or censorship-resistance properties of Psiphon tunnels — that
  is the product's purpose, not a vulnerability in this manager.
- Attacks that require the operator to make choices the software warns about
  (for example binding the API to a public interface without a firewall).
- Social engineering of the server operator.

## Security model

Understanding this model is the fastest way to judge whether something is a
real vulnerability:

1. **Everything runs as root.** Starting/stopping tunnels requires root, so
   the manager, both systemd units and the tunnels themselves run with full
   privileges. The security design therefore focuses on (a) who can reach the
   manager, (b) what a local unprivileged user can do to it, and (c) limiting
   blast radius with systemd sandboxing.
2. **The HTTP API is the only network-facing surface.** It binds to
   `127.0.0.1` by default. Every request must present the API token as a
   header (`Authorization: Bearer <token>` or `X-Api-Token: <token>`); there
   is deliberately no query-parameter form. Comparison is constant-time, and
   repeated failures from one address are throttled (`429`).
3. **The API token is a root-equivalent secret.** It is 192 bits of CSPRNG
   entropy, stored at `/etc/psiphon/api-token` with `0600` permissions
   (created with the mode from the start, not chmod'ed after). Anyone with the
   token can start/stop tunnels and change ports as root.
4. **The update path is a supply-chain trust decision.** The bootstrap
   installer and `xp update` fetch code and the Psiphon core binary over TLS
   from GitHub, and execute them as root. Downloads are sanity-checked (size +
   ELF/x86-64 header) but not cryptographically pinned, because upstream does
   not publish checksums. Operators who want a frozen supply chain can set
   `XPSIPHON_GITHUB_REF` to a specific tag.
5. **Runtime directories are defended against local attacks.** The data root
   defaults to `/tmp/psiphon` (world-writable parent), so the manager refuses
   to use a runtime directory that is not owned by the current user or is
   group/world-writable — a pre-planted directory would otherwise redirect
   root-run tunnel writes into attacker-chosen locations.
6. **systemd sandboxing bounds the blast radius.** Both units run with
   `NoNewPrivileges=true`, `ProtectSystem=strict`, `ProtectHome=true`,
   `MemoryDenyWriteExecute=true`, `RestrictSUIDSGID=true`, kernel-protection
   flags and a bounded `ReadWritePaths`. `PrivateTmp` is intentionally off so
   that tunnels started by systemd share the same data root as tunnels started
   from the CLI.

## Security testing

This project undergoes structured security reviews built on Google's
**[Mantis](https://github.com/google/mantis)** methodology (threat model →
plan → hunter pass → independent review → exploit reproduction → patch →
re-attack → calibrated report). The pass completed for 2.1.0 raised seven
findings — all reproduced where possible, all patched, and all covered by
regression tests in `tests/` (see the `Security` section of the
[CHANGELOG](CHANGELOG.md)). The full report is kept out of the repository;
ask the maintainer if you need it.

## Known accepted risks

These are deliberate, documented tradeoffs rather than oversights:

1. **One-line install (`curl … | bash`)** executes network-fetched code as
   root, protected by TLS only. If you require a frozen supply chain, download
   the installer, review it, and run it locally (`--offline` is supported).
2. **No checksum pinning of the Psiphon core binary** — upstream publishes no
   checksums to pin against. The installer verifies size and ELF/x86-64
   headers as a baseline; a real integrity guarantee needs upstream support.
3. **Binding the API to a public interface** (`--host 0.0.0.0`) exposes the
   API to the network. The CLI warns about this; do it only with a firewall
   restricting the port to trusted IPs.
4. **The API unit can write the systemd unit directory**, because the API can
   manage autostart. The API token is therefore root-equivalent by design.

## Hardening checklist for operators

- Keep the API on `127.0.0.1` (the default). If you must expose it, allow only
  trusted IPs through the firewall.
- `chmod 600 /etc/psiphon/api-token` is enforced at creation; never copy the
  token into URLs or shell history.
- Keep the server updated (`sudo xp update`); security fixes land in releases.
- The server does not need any inbound ports open for the tunnels to work —
  all proxy listeners are loopback-only. Only open ports if you deliberately
  want LAN/VPN peers to reach your proxies, and restrict the sources.
- Prefer a dedicated, non-multi-tenant server: the mitigations above assume
  the only other actor on the box is you.
