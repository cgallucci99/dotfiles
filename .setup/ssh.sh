# Labels this machine's SSH key, e.g.
#   camden.gallucci@C73CQ6QP54 · MacBook Pro · macOS 26.6.2 arm64 · 2026-10-15
ssh_key_label() {
  if [ "$(uname -s)" = "Darwin" ]; then
    device="$(system_profiler SPHardwareDataType 2> /dev/null | awk -F ': ' '/Model Name/ { print $2 }')"
    system="macOS $(sw_vers -productVersion)"
  else
    device="$(cat /sys/devices/virtual/dmi/id/product_name 2> /dev/null || echo Linux)"
    # shellcheck source=/dev/null
    system="$(. /etc/os-release && echo "$PRETTY_NAME")"
  fi

  echo "$(id -un)@$(uname -n | cut -d . -f 1) · ${device:-Unknown} · $system $(uname -m) · $1"
}
