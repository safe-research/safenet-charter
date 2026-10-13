# Dev-only image for this repo's tooling (scripts/charter-ipfs.sh, justfile).
# Not published anywhere - built locally by the Dev Containers extension / Codespaces
# / `podman build` or `docker build`. Supports both amd64 and arm64 natively (no
# emulation needed) - arch is detected at build time via `uname -m`.
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      jq \
      just \
      xxd \
    && rm -rf /var/lib/apt/lists/*

# kubo (ipfs CLI), pinned + checksum-verified for both architectures.
# Downloaded from kubo's GitHub release mirror rather than dist.ipfs.tech - same
# bytes (checksums cross-checked), but a more reliable host to reach from CI/sandboxes.
RUN set -eu; \
    case "$(uname -m)" in \
      x86_64) arch=amd64; sum="771112001cef93d0c77fa61450990a3eb9d86ebd9cda6ba5ffed550db3f163b97426f01f6fe7e4d9532699474385f3e524b7499d55e4d92848aa0b02899b5c9e" ;; \
      aarch64) arch=arm64; sum="73df2457f6b350bab0373a8e3cb5d3afa0b7c87ddfe3c3ed153700a9cc5c9da390fbb1af8c0c9072c4fd78f862dfd1a96abee6ef7490711038af7f39c822e21c" ;; \
      *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;; \
    esac; \
    curl -sSL -o /tmp/kubo.tar.gz "https://github.com/ipfs/kubo/releases/download/v0.35.0/kubo_v0.35.0_linux-${arch}.tar.gz"; \
    echo "${sum}  /tmp/kubo.tar.gz" | sha512sum -c -; \
    tar -xzf /tmp/kubo.tar.gz -C /tmp; \
    bash /tmp/kubo/install.sh; \
    rm -rf /tmp/kubo /tmp/kubo.tar.gz; \
    ipfs init

# Foundry (cast), pinned + checksum-verified for both architectures.
RUN set -eu; \
    case "$(uname -m)" in \
      x86_64) arch=amd64; sum="6c66ffcc55fa4249197721baa3098bc208014ea1d8aa04b2ed50ac6bccffb226" ;; \
      aarch64) arch=arm64; sum="5bdce3dade8b6f0a65d4fccf6908426aee4905a988b08dce79d0a72fe7498310" ;; \
      *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;; \
    esac; \
    curl -sSL -o /tmp/foundry.tar.gz "https://github.com/foundry-rs/foundry/releases/download/v1.8.5/foundry_v1.8.5_linux_${arch}.tar.gz"; \
    echo "${sum}  /tmp/foundry.tar.gz" | sha256sum -c -; \
    tar -xzf /tmp/foundry.tar.gz -C /usr/local/bin; \
    rm -f /tmp/foundry.tar.gz

WORKDIR /workspaces/safenet-charter
