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

`scripts/charter-ipfs.sh` supports the IPFS/ENS steps above:

```sh
# Preview the CID Safenet_Arbitration_Charter.md would get on IPFS.
# Requires the kubo `ipfs` CLI (https://docs.ipfs.tech/install/command-line/).
./scripts/charter-ipfs.sh cid

# Upload it to IPFS via Pinata. Requires PINATA_JWT, either exported
# or set in a git-ignored .env file in the repo root.
./scripts/charter-ipfs.sh pin

# Compare the local file against whatever charter.safenet-gov.eth
# currently references onchain, printing a diff if they differ.
# Requires curl, jq, and xxd.
./scripts/charter-ipfs.sh diff
```

Each subcommand also accepts an explicit file path, and `RPC_URL` / `IPFS_GATEWAY_URL` env vars override the defaults. All of these (plus `PINATA_JWT`) can also be set in a git-ignored `.env` file in the repo root — copy `.env.example` to get started:

```sh
cp .env.example .env
```
