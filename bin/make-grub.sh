#!/bin/sh

# 1) Look at the top of each shell script to determine how to download the ISO
# 2) Put the downloaded ISO file into ../iso (create directory if needed)t
# 3) Run this script
# 4) Copy iso and grub directories to flash drive

debug() { ! "${log_debug-false}" || log "DEBUG: $*" >&2; }
log() { printf '%s\n' "$*"; }
warn() { log "WARNING: $*" >&2; }
error() { log "ERROR: $*" >&2; }
fatal() { error "$*"; exit 1; }
try() { "$@" || fatal "'$@' failed"; }

mydir=$(cd "$(dirname "$0")" && pwd -L) || fatal "Unable to determine script directory"

output=${mydir}/../grub/grub.cfg
export output

try cat "${mydir}"/../template/grub.header > "${output}"

. "${mydir}"/ubuntu || fatal "Error executing ubuntu"

. "${mydir}"/utility || fatal "Error executing utility"

try cat "${mydir}"/../template/grub.footer >> "${output}"
