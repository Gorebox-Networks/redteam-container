#!/bin/bash
# Test harness for set-credentials.sh fail-closed behaviour.
# Runs the real script logic against stub chpasswd/vncpasswd/passwd so no real
# credential is ever applied and nothing touches the host.

PASS=0
FAIL=0

mk_stubs() {
  mkdir -p /tmp/stub
  cat > /tmp/stub/chpasswd <<'EOF'
#!/bin/bash
echo "$@" | sed -E 's/:[^:]*$/:<REDACTED>/'
echo "CHPASSWD_INVOKED" >> /tmp/stub/calls
EOF
  cat > /tmp/stub/vncpasswd <<'EOF'
#!/bin/bash
cat > /dev/null
echo "VNCPASSWD_INVOKED" >> /tmp/stub/calls
EOF
  cat > /tmp/stub/passwd <<'EOF'
#!/bin/bash
echo "PASSWD_INVOKED" >> /tmp/stub/calls
exit 0
EOF
  chmod +x /tmp/stub/*
}

run_case() {
  local desc="$1" expect="$2" passval="$3"
  rm -f /tmp/stub/calls
  mkdir -p $HOME/.vnc
  printf '# test\nPermitRootLogin yes\nPasswordAuthentication yes\nPubkeyAuthentication no\n' > /tmp/stub/sshd_config

  # Rewrite the absolute paths in the script to our stubs.
  sed -e 's#^SSHD_CONFIG=.*#SSHD_CONFIG=/tmp/stub/sshd_config#' \
      -e 's#$HOME/.vnc/passwd#/tmp/stub/vncpasswd_out#g' \
      -e 's#chpasswd#/tmp/stub/chpasswd#g' \
      -e 's#vncpasswd -f#/tmp/stub/vncpasswd -f#g' \
      "$SCRIPT" > /tmp/stub/under_test.sh
  chmod +x /tmp/stub/under_test.sh

  PATH=/tmp/stub:$PATH
  export SSHPASSWORD="$passval"
  /tmp/stub/under_test.sh >/tmp/stub/out 2>&1
  local rc=$?

  local got="keys-only"
  grep -q 'prohibit-password' /tmp/stub/sshd_config && got="keys-only"
  grep -qE '^PasswordAuthentication no' /tmp/stub/sshd_config && got="keys-only"
  if grep -q 'CHPASSWD_INVOKED' /tmp/stub/calls 2>/dev/null; then got="password-set"; fi

  if [ "$got" = "$expect" ]; then
    echo "  PASS  $desc  -> $got (rc=$rc)"
    PASS=$((PASS+1))
  else
    echo "  FAIL  $desc  -> expected $expect, got $got (rc=$rc)"
    sed 's/^/          /' /tmp/stub/out
    FAIL=$((FAIL+1))
  fi
}

SCRIPT="${1:?path to set-credentials.sh}"
mk_stubs

echo "=== fail-closed contract ==="
run_case "no SSHPASSWORD at all"      "keys-only"    ""
run_case "SSHPASSWORD empty string"   "keys-only"    ""
run_case "SSHPASSWORD whitespace"     "keys-only"    "            "
run_case "SSHPASSWORD too short (11)" "keys-only"    "shortpass11"
run_case "SSHPASSWORD exactly 12"     "password-set" "abcdefghijkl"
run_case "SSHPASSWORD strong"         "password-set" "a-very-long-lab-password-2026"

echo ""
echo "=== final sshd state after the strong-password case ==="
grep -E '^(PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)' /tmp/stub/sshd_config

echo ""
echo "PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ] || exit 1