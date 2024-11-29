#!/usr/bin/env bash
if [[ -f /sys/class/dmi/id/bios_vendor && "$(cat /sys/class/dmi/id/bios_vendor)" = "Google" ]]; then
  echo "Google"
else
  echo "local"
fi
