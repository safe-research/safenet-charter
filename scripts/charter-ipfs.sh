#!/usr/bin/env bash
#
# Charter IPFS/ENS tooling.
#
# Subcommands:
#   cid   [file]  Compute the IPFS CID a file would get (requires kubo's `ipfs` CLI).
#   pin   [file]  Upload a file to IPFS via Pinata (requires PINATA_JWT).
#   diff  [file]  Compare a local file against the content currently referenced
#                 by the ENS name's onchain contenthash record.
#
# Env overrides: RPC_URL, IPFS_GATEWAY_URL, PINATA_JWT.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_FILE="$REPO_ROOT/Safenet_Arbitration_Charter.md"

# The ENS name this tool checks, and its namehash. Both are fixed constants, not
# runtime-configurable: computing namehash() for an arbitrary name needs real
# Keccak-256, which isn't available in bash/jq/python's stdlib, so instead this
# is hardcoded for this one name. To point at a different name, regenerate both
# with: cast namehash "<name>" (cross-checked here against viem's namehash()).
ENS_NAME="charter.safenet-gov.eth"
ENS_NODE="0x8eb28b73557db9dbf11eb3284826984b167db85cbc1ae64e80ba91f9167d07ea"

ENS_REGISTRY="0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"
# Function selectors (fixed ABI constants, verified with `cast sig`):
SEL_RESOLVER="0x0178b8bf"   # resolver(bytes32)
SEL_CONTENTHASH="0xbc1c58d1" # contenthash(bytes32)

die() {
  echo "error: $*" >&2
  exit 1
}

require() {
  command -v "$1" >/dev/null 2>&1 || die "'$1' is required but not installed."
}

# Loads KEY=VALUE lines from .env into the environment, without clobbering
# anything the caller already set explicitly (real env vars always win).
load_dotenv() {
  local f="$REPO_ROOT/.env"
  [ -f "$f" ] || return 0
  local line key value
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|'#'*) continue ;;
    esac
    key="${line%%=*}"
    value="${line#*=}"
    value="${value%\"}"; value="${value#\"}"
    value="${value%\'}"; value="${value#\'}"
    if [ -z "${!key+x}" ]; then
      export "$key=$value"
    fi
  done < "$f"
}

# eth_call helper: prints the raw hex `result` field (no ABI decoding).
eth_call() {
  local to="$1" data="$2"
  local payload response result
  payload=$(printf '{"jsonrpc":"2.0","id":1,"method":"eth_call","params":[{"to":"%s","data":"%s"},"latest"]}' "$to" "$data")
  response=$(curl -sS --fail --max-time 20 -H 'Content-Type: application/json' -d "$payload" "$RPC_URL") \
    || die "eth_call to $to failed (RPC_URL=$RPC_URL)"
  if echo "$response" | jq -e '.error' >/dev/null 2>&1; then
    die "eth_call to $to returned an RPC error: $(echo "$response" | jq -c '.error')"
  fi
  result=$(echo "$response" | jq -r '.result')
  [ "$result" != "null" ] || die "eth_call to $to returned no result"
  echo "$result"
}

# Strips the ABI head from a dynamic `bytes` return value, printing the raw payload hex (no 0x).
abi_decode_bytes() {
  local hex="${1#0x}"
  local len_hex payload_hex len_bytes len_hex_chars
  [ "${#hex}" -ge 128 ] || die "unexpected ABI response for a dynamic bytes return: 0x$hex"
  # word 1 = offset (ignored, always 0x20 for a single dynamic return), word 2 = length
  len_hex="${hex:64:64}"
  len_bytes=$((16#$len_hex))
  len_hex_chars=$((len_bytes * 2))
  payload_hex="${hex:128:$len_hex_chars}"
  echo "$payload_hex"
}

# Decodes an EIP-1577 ipfs-ns contenthash payload (hex, no 0x) into a CIDv1 string.
decode_ipfs_contenthash() {
  local hex="$1"
  case "$hex" in
    e301*) ;;
    "") die "contenthash is empty" ;;
    *) die "contenthash is not an ipfs-ns record (got prefix ${hex:0:4})" ;;
  esac
  local cid_hex="${hex:4}"
  local cid_bin b32
  cid_bin=$(mktemp)
  trap 'rm -f "$cid_bin"' RETURN
  echo -n "$cid_hex" | xxd -r -p > "$cid_bin"
  if command -v base32 >/dev/null 2>&1; then
    b32=$(base32 -w0 < "$cid_bin" | tr 'A-Z' 'a-z' | tr -d '=')
  elif command -v python3 >/dev/null 2>&1; then
    b32=$(python3 -c "import base64,sys; print(base64.b32encode(sys.stdin.buffer.read()).decode().lower().rstrip('='))" < "$cid_bin")
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
  [ -n "${PINATA_JWT:-}" ] || die "PINATA_JWT is not set (export it, or put it in $REPO_ROOT/.env)"

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
  require curl
  require jq
  require xxd

  local resolver
  resolver=$(eth_call "$ENS_REGISTRY" "${SEL_RESOLVER}${ENS_NODE#0x}")
  # left-pad-stripped address is the last 20 bytes (40 hex chars) of the 32-byte word
  resolver="0x${resolver: -40}"
  if [ "$resolver" = "0x0000000000000000000000000000000000000000" ]; then
    echo "No resolver set for $ENS_NAME yet. Nothing to diff."
    return 0
  fi

  local raw_result contenthash_hex cid
  raw_result=$(eth_call "$resolver" "${SEL_CONTENTHASH}${ENS_NODE#0x}")
  contenthash_hex=$(abi_decode_bytes "$raw_result")
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
    local_cid=$(ipfs add --only-hash --cid-version 1 -Q "$file") \
      || die "'ipfs add' failed while computing the local CID"
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
  pin   [file]  Upload a file to IPFS via Pinata. Requires PINATA_JWT (env or .env).
  diff  [file]  Diff a local file against the content referenced by ${ENS_NAME}'s
                onchain contenthash record.

Env overrides: RPC_URL, IPFS_GATEWAY_URL, PINATA_JWT.
EOF
  exit 1
}

main() {
  load_dotenv
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
