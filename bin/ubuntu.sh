#!/bin/sh

# Download ISO files from https://www.ubuntu.com

debug() { ! "${log_debug-false}" || log "DEBUG: $*" >&2; }
log() { printf '%s\n' "$*"; }
warn() { log "WARNING: $*" >&2; }
error() { log "ERROR: $*" >&2; }
fatal() { error "$*"; exit 1; }
try() { "$@" || fatal "'$@' failed"; }

mydir=$(cd "$(dirname "$0")" && pwd -L) || fatal "Unable to determine script directory"

all_entries=''
found_entry=0

if [ -e "${mydir}/../iso/ubuntu-18.04.1-desktop-amd64.iso" ]; then
    found_entry=1
    menuentry='
    menuentry "Ubuntu Live CD - 18.04 LTS - 64bit Desktop" {
        set iso="/iso/ubuntu-18.04.1-desktop-amd64.iso"
        loopback loop $iso
        linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$iso noprompt noeject splash --
        initrd (loop)/casper/initrd.lz
    }
'
    all_entries="${all_entries}${menuentry}"
fi

if [ -e "${mydir}/../iso/ubuntu-18.04.1-live-server-amd64.iso" ]; then
    found_entry=1
    menuentry='
    menuentry "Ubuntu Live CD - 18.04 LTS - 64bit Server" {
        set iso="/iso/ubuntu-18.04.1-live-server-amd64.iso"
        loopback loop $iso
        linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$iso noprompt noeject --
        initrd (loop)/casper/initrd
    }
'
    all_entries="${all_entries}${menuentry}"
fi

if [ -e "${mydir}/../iso/ubuntu-mini-16.04-amd64.iso" ]; then
    found_entry=1
    menuentry='
    menuentry "Ubuntu 16.04/Xenial LTS - 64bit Mini-Installer - GA" {
        set iso="/iso/ubuntu-mini-16.04-amd64.iso"
        loopback loop $iso
        linux (loop)/linux boot=casper iso-scan/filename=$iso noprompt noeject
        initrd (loop)/initrd.gz
    }
'
    all_entries="${all_entries}${menuentry}"
fi

if [ -e "${mydir}/../iso/ubuntu-mini-16.04-i386.iso" ]; then
    found_entry=1
    menuentry='
    menuentry "Ubuntu 16.04/Xenial LTS - 32bit Mini-Installer - GA" {
        set iso="/iso/ubuntu-mini-16.04-i386.iso"
        loopback loop $iso
        linux (loop)/linux boot=casper iso-scan/filename=$iso noprompt noeject
        initrd (loop)/initrd.gz
    }
'
    all_entries="${all_entries}${menuentry}"
fi

if [ ${found_entry} -eq 1 ]; then
    debug "Found an entry, output submenu"
    echo "submenu 'Ubuntu >>' {" >> "${output}"
    echo "${all_entries}" >> "${output}"
    echo "}" >> "${output}"
fi
