#!/usr/bin/env bash
#
# Charter IPFS/ENS tooling.
#
# Subcommands:
#   cid   [file]  Compute the IPFS CID a file would get (requires kubo's `ipfs` CLI).
#   pin   [file]  Upload a file to IPFS via Pinata (requires PINATA_JWT).
#   diff  [file]  Compare a local file against the content currently referenced
#                 by the ENS name's onchain contenthash record (requires `cast`,
#                 from Foundry).
#
# Env overrides: RPC_URL, IPFS_GATEWAY_URL, ENS_NAME, PINATA_JWT.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_FILE="$REPO_ROOT/Safenet_Arbitration_Charter.md"

ENS_NAME="${ENS_NAME:-charter.safenet-gov.eth}"
ENS_REGISTRY="0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"

die() {
  echo "error: $*" >&2
  exit 1
}

require() {
  command -v "$1" >/dev/null 2>&1 || die "'$1' is required but not installed."
}

# Decodes an EIP-1577 ipfs-ns contenthash payload (hex, no 0x) into a CIDv1 string.
decode_ipfs_contenthash() {
  local hex="$1"
  case "$hex" in
    e301*) ;;
    "") die "contenthash is empty" ;;
    *) die "contenthash is not an ipfs-ns record (got prefix ${hex:0:4})" ;;
  esac
  local cid_hex="${hex:4}" b32
  if command -v base32 >/dev/null 2>&1; then
    b32=$(echo -n "$cid_hex" | xxd -r -p | base32 -w0 | tr 'A-Z' 'a-z' | tr -d '=')
  elif command -v python3 >/dev/null 2>&1; then
    b32=$(echo -n "$cid_hex" | xxd -r -p | python3 -c "import base64,sys; print(base64.b32encode(sys.stdin.buffer.read()).decode().lower().rstrip('='))")
  else
    die "need either 'base32' or 'python3' to encode the CID"
  fi
  echo "b${b32}"
}

cmd_cid() {
  local file="${1:-$DEFAULT_FILE}"
  [ -f "$file" ] || die "no such file: $file"
  require ipfs
  if ! ipfs add --only-hash --cid-version 1 -Q "$file"; then
    die "'ipfs add' failed. If this is the first time using kubo on this machine, run 'ipfs init' once and retry."
  fi
}

cmd_pin() {
  local file="${1:-$DEFAULT_FILE}"
  [ -f "$file" ] || die "no such file: $file"
  require curl
  require jq
  [ -n "${PINATA_JWT:-}" ] || die "PINATA_JWT is not set in the environment"

  local raw http_status response cid
  raw=$(curl -sS --max-time 60 -w '\n%{http_code}' \
    -H "Authorization: Bearer $PINATA_JWT" \
    -F "file=@${file}" \
    -F "network=public" \
    -F "name=$(basename "$file")" \
    -F "cid_version=v1" \
    "https://uploads.pinata.cloud/v3/files") || die "upload to Pinata failed (couldn't reach the API)"

  http_status="${raw##*$'\n'}"
  response="${raw%$'\n'"$http_status"}"

  if [ "$http_status" -lt 200 ] || [ "$http_status" -ge 300 ]; then
    die "Pinata upload failed (HTTP $http_status): $response"
  fi

  cid=$(echo "$response" | jq -r '.data.cid // empty')
  [ -n "$cid" ] || die "Pinata response did not include a CID: $response"

  echo "CID: $cid"
  echo "Gateway: $IPFS_GATEWAY_URL/$cid"
}

cmd_diff() {
  local file="${1:-$DEFAULT_FILE}"
  [ -f "$file" ] || die "no such file: $file"
  require cast
  require curl
  require xxd

  local node resolver
  node=$(cast namehash "$ENS_NAME") || die "'cast namehash' failed"
  resolver=$(cast call "$ENS_REGISTRY" "resolver(bytes32)(address)" "$node" --rpc-url "$RPC_URL") \
    || die "eth_call to the ENS registry failed (RPC_URL=$RPC_URL)"
  if [ "$resolver" = "0x0000000000000000000000000000000000000000" ]; then
    echo "No resolver set for $ENS_NAME yet. Nothing to diff."
    return 0
  fi

  local raw_contenthash contenthash_hex cid
  raw_contenthash=$(cast call "$resolver" "contenthash(bytes32)(bytes)" "$node" --rpc-url "$RPC_URL") \
    || die "eth_call to the resolver failed (RPC_URL=$RPC_URL)"
  contenthash_hex="${raw_contenthash#0x}"
  if [ -z "$contenthash_hex" ]; then
    echo "No contenthash set for $ENS_NAME yet. Nothing to diff."
    return 0
  fi

  cid=$(decode_ipfs_contenthash "$contenthash_hex")
  echo "Onchain CID for $ENS_NAME: $cid"

  local ok=0

  # Check 1: does the local file hash to the same CID? (only possible if kubo is installed)
  if command -v ipfs >/dev/null 2>&1; then
    local local_cid
    local_cid=$(cmd_cid "$file")
    if [ "$local_cid" = "$cid" ]; then
      echo "✓ CID matches ($local_cid)"
    else
      echo "✗ CID differs: local=$local_cid onchain=$cid"
      ok=1
    fi
  else
    echo "  (kubo not installed - skipping local CID comparison; install it for a stronger check)"
  fi

  # Check 2: sanity-check by diffing actual fetched content against the local file.
  local remote_tmp
  remote_tmp=$(mktemp)
  if ! curl -sS --fail --max-time 30 -L "$IPFS_GATEWAY_URL/$cid" -o "$remote_tmp"; then
    rm -f "$remote_tmp"
    die "failed to fetch $IPFS_GATEWAY_URL/$cid"
  fi

  if diff -u "$remote_tmp" "$file"; then
    rm -f "$remote_tmp"
    echo "✓ Content matches: $file has no differences from the onchain record."
  else
    echo
    echo "✗ Content differs between the onchain record (left) and $file (right)."
    rm -f "$remote_tmp"
    ok=1
  fi

  return "$ok"
}

usage() {
  cat >&2 <<EOF
Usage: $(basename "$0") <cid|pin|diff> [file]

  cid   [file]  Compute the IPFS CID for a file (default: Safenet_Arbitration_Charter.md).
                Requires the kubo 'ipfs' CLI.
  pin   [file]  Upload a file to IPFS via Pinata. Requires PINATA_JWT set in the
                environment (export it yourself, or pass it via your container
                runtime's --env-file).
  diff  [file]  Diff a local file against the content referenced by ${ENS_NAME}'s
                onchain contenthash record. Requires 'cast' (from Foundry).

Env overrides: RPC_URL, IPFS_GATEWAY_URL, ENS_NAME, PINATA_JWT.
EOF
  exit 1
}

main() {
  RPC_URL="${RPC_URL:-https://ethereum-rpc.publicnode.com}"
  IPFS_GATEWAY_URL="${IPFS_GATEWAY_URL:-https://gateway.pinata.cloud/ipfs}"

  local sub="${1:-}"
  [ -n "$sub" ] || usage
  shift
  case "$sub" in
    cid) cmd_cid "$@" ;;
    pin) cmd_pin "$@" ;;
    diff) cmd_diff "$@" ;;
    *) usage ;;
  esac
}

main "$@"
