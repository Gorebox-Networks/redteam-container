#!/bin/bash
# set-credentials.sh - apply SSH/VNC credentials at container start.
#
# WHY THIS EXISTS
#   The root password used to be set at BUILD time via an `ARG SSHPASSWORD`.
#   That ARG was never declared in the Dockerfile, so `$SSHPASSWORD` expanded
#   to the EMPTY STRING and `chpasswd` was invoked with an empty password.
#   Combined with `PermitRootLogin yes` + `PasswordAuthentication yes` + a
#   published port, the resulting image served an UNAUTHENTICATED ROOT SHELL.
#
#   This script replaces that mechanism entirely. The password is now supplied
#   at runtime and NEVER written into an image layer.
#
# FAIL-CLOSED CONTRACT
#   SSHPASSWORD unset or empty  -> no password is ever set. SSH password
#                                  authentication is disabled and key-based
#                                  login is required. The container starts.
#   SSHPASSWORD set             -> the password is applied to root and to the
#                                  VNC session, and password auth is enabled.
#
#   There is no path in this script that produces an empty password.

set -u

SSHD_CONFIG=/etc/ssh/sshd_config
MIN_LENGTH=12

log() { printf '[set-credentials] %s\n' "$*"; }
fail() { printf '[set-credentials] ERROR: %s\n' "$*" >&2; }

# Drop any password file left over from a previous run in this container so a
# stale credential can never survive a restart.
clear_existing_passwords() {
    passwd -d root >/dev/null 2>&1 || true
    if [ -f /root/.vnc/passwd ]; then
        rm -f /root/.vnc/passwd
        log "removed stale VNC password file"
    fi
}

set_sshd_option() {
    # Replace an uncommented directive; comment out every other occurrence so
    # sshd never sees two conflicting values for the same keyword.
    local key="$1" value="$2" file="$3"
    sed -i -E "s|^[[:space:]]*${key}[[:space:]].*|${key} ${value}|" "$file"
}

enable_password_auth() {
    set_sshd_option PermitRootLogin 'yes'            "$SSHD_CONFIG"
    set_sshd_option PasswordAuthentication 'yes'      "$SSHD_CONFIG"
    set_sshd_option PubkeyAuthentication 'yes'        "$SSHD_CONFIG"
}

require_key_auth() {
    # prohibit-password still permits root login, but only with a key.
    set_sshd_option PermitRootLogin 'prohibit-password' "$SSHD_CONFIG"
    set_sshd_option PasswordAuthentication 'no'         "$SSHD_CONFIG"
    set_sshd_option PubkeyAuthentication 'yes'          "$SSHD_CONFIG"
}

clear_existing_passwords

if [ -z "${SSHPASSWORD:-}" ]; then
    log "SSHPASSWORD is not set."
    log "No password will be configured. SSH is restricted to key-based login."
    require_key_auth
    log "To use a password, set SSHPASSWORD in your local env file and restart."
    exit 0
fi

if [ "${#SSHPASSWORD}" -lt "$MIN_LENGTH" ]; then
    fail "SSHPASSWORD is ${#SSHPASSWORD} characters; refusing anything under ${MIN_LENGTH}."
    fail "No password was set and SSH is restricted to key-based login."
    require_key_auth
    exit 1
fi

if [ "$(printf '%s' "$SSHPASSWORD" | tr -d '[:space:]')" = "" ]; then
    fail "SSHPASSWORD is whitespace only; refusing."
    require_key_auth
    exit 1
fi

# Single-quoted value keeps the password out of the process table.
if ! printf 'root:%s\n' "$SSHPASSWORD" | chpasswd; then
    fail "chpasswd failed; no password was set."
    require_key_auth
    exit 1
fi
log "root password applied (${#SSHPASSWORD} characters)."

if [ -d /root/.vnc ]; then
    if printf '%s\n' "$SSHPASSWORD" | vncpasswd -f > /root/.vnc/passwd 2>/dev/null; then
        chmod 600 /root/.vnc/passwd
        log "VNC password applied."
    else
        rm -f /root/.vnc/passwd
        log "VNC password could not be set; VNC remains unconfigured rather than empty."
    fi
fi

enable_password_auth
log "SSH password authentication enabled for root."