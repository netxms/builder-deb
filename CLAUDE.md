# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

Per-distro Docker images for NetXMS DEB package building. Each image is a vanilla distro container with APT repos configured and build tools pre-installed, used as base images in Drone CI steps.

### Image Tags

Published to `ghcr.io/netxms/builder-deb`:

| Tag | Base Image |
|-----|-----------|
| `trixie` | `debian:trixie` |
| `bookworm` | `debian:bookworm` |
| `bullseye` | `debian:bullseye` |
| `noble` | `ubuntu:noble` |
| `jammy` | `ubuntu:jammy` |
| `focal` | `ubuntu:focal` |

All images are multi-arch: `linux/amd64`, `linux/arm64`.

### Dockerfile Build Args

- `BASE_IMAGE` — base distro image (e.g. `debian:bookworm`, `ubuntu:noble`)
- `DISTRO_TYPE` — `debian` or `ubuntu`
- `DISTRO_VERSION` — codename (e.g. `bookworm`, `noble`)

### Bundled Files

- `files/apache-maven-3.9.14-bin.tar.gz` — Maven, installed to `/opt/`
- `files/instantclient_<arch>.tar.bz2` — Oracle Instant Client (per-arch), installed to `/opt/`

## Common Commands

```bash
make all              # Build all 6 images
make build-trixie     # Build single image
make clean            # Remove all images
```

## CI/CD

GitHub Actions workflow (`.github/workflows/package.yml`) builds all 6 images in parallel with multi-arch support on push to master.

## Distribution Targets

- Debian: trixie, bookworm, bullseye
- Ubuntu: noble, jammy, focal
