charter_file := "Safenet_Arbitration_Charter.md"

default:
    @just --list

# Preview the IPFS CID a file would get. Requires kubo's `ipfs` CLI.
cid file=charter_file:
    ./scripts/charter-ipfs.sh cid {{file}}

# Upload a file to IPFS via Pinata. Requires PINATA_JWT set in the environment.
pin file=charter_file:
    ./scripts/charter-ipfs.sh pin {{file}}

# Diff a file against what charter.safenet-gov.eth currently references onchain.
# Requires `cast` (from Foundry).
diff file=charter_file:
    ./scripts/charter-ipfs.sh diff {{file}}
