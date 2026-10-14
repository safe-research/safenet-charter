# Safenet Arbitration Charter

> **Work in progress.** This repository and the process described below are not yet approved by SafeDAO. Nothing here is authoritative.

This repository is a convenience workspace for drafting and reviewing the [Safenet Arbitration Charter](./Safenet_Arbitration_Charter.md).

## Intended process (provisional, subject to SafeDAO approval)

The following process is proposed but not yet in effect:

1. Draft and review changes on GitHub.
2. Publish the proposed Charter version to IPFS.
3. Submit a SafeDAO proposal to approve the version and execute an ENS update of `charter.safenet-gov.eth` via SafeSnap.
4. Monitor execution of the SafeSnap transaction.

## What is (and isn't) authoritative

GitHub files, commits, pull requests, merges, tags, and releases are **not** authoritative and do not make any Charter version effective. The effective Charter is only the IPFS document referenced by `charter.safenet-gov.eth`, following the applicable SafeDAO-approved update.

## Tooling

### Prerequisites

Either use the devcontainer (see below, nothing to install), or install these yourself:

- [`just`](https://just.systems/man/en/packages.html) — runs the recipes below.
- [kubo](https://docs.ipfs.tech/install/command-line/) (`ipfs`) — needed for `cid`, and for the local-CID check that `diff` does if it's available. Run `ipfs init` once after installing.
- [Foundry](https://getfoundry.sh) (`cast`) — needed for `diff`.
- `curl`, `jq`, `xxd` — needed for `pin`/`diff`; present by default on most systems.

### Using the devcontainer

Gets you all of the above with nothing installed locally:

- **VS Code**: open the repo, Command Palette → "Dev Containers: Reopen in Container" (or open it as a GitHub Codespace). If you use Podman instead of Docker, first add `"dev.containers.dockerPath": "podman"` to your VS Code settings.
- **CLI, with Docker**:

  ```sh
  docker build -f .devcontainer/Dockerfile -t safenet-charter-dev .
  docker run --rm -v "$PWD:/workspaces/safenet-charter" safenet-charter-dev just diff
  ```

- **CLI, with Podman**:

  ```sh
  podman build -f .devcontainer/Dockerfile -t safenet-charter-dev .
  podman run --rm -v "$PWD:/workspaces/safenet-charter:Z" safenet-charter-dev just diff
  ```

  (the `:Z` volume flag is for SELinux-enabled hosts, e.g. Fedora/RHEL; harmless to include elsewhere)

The image's `WORKDIR` is already the repo path, so any `just` recipe (or `bash`, for an interactive shell) can be passed directly as the command — no need to `cd` first. kubo, Foundry, and `just` are already installed in the image, and `ipfs init` has already been run during the build.

### Commands

`scripts/charter-ipfs.sh` supports the IPFS/ENS steps above, and a `justfile` wraps it:

```sh
# Preview the CID Safenet_Arbitration_Charter.md would get on IPFS.
# Requires the kubo `ipfs` CLI (https://docs.ipfs.tech/install/command-line/).
just cid

# Upload it to IPFS via Pinata. Requires PINATA_JWT set in the environment
# (export it yourself, or pass it via your container runtime's --env-file).
just pin

# Compare the local file against whatever charter.safenet-gov.eth
# currently references onchain, printing a diff if they differ.
# Requires curl, xxd, and `cast` (from Foundry: https://getfoundry.sh).
just diff
```

Each `just` recipe forwards to the matching `./scripts/charter-ipfs.sh <subcommand>`, which also accepts an explicit file path directly. The script only reads real environment variables (no `.env` file support) — set what you need via `export`, or your container runtime's env-file flag (e.g. `podman run --env-file`):

- `PINATA_JWT` — required by `pin`. Create a key with `Files:Write` scope at <https://app.pinata.cloud/developers/api-keys>.
- `RPC_URL` — Ethereum JSON-RPC endpoint used by `diff`. Default: `https://ethereum-rpc.publicnode.com`.
- `IPFS_GATEWAY_URL` — gateway used by `diff`/`pin`. Default: `https://gateway.pinata.cloud/ipfs`.
- `ENS_NAME` — ENS name `diff` checks. Default: `charter.safenet-gov.eth`.
