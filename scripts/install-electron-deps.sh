#!/usr/bin/env bash
set -euo pipefail

BASE_PACKAGES=(
  xvfb
  dbus-x11
  libatk1.0-0
  libatk-bridge2.0-0
  libatspi2.0-0
  libcairo2
  libcups2
  libdrm2
  libgbm1
  libglib2.0-0
  libgtk-3-0
  libnss3
  libpango-1.0-0
  libpangocairo-1.0-0
  libxcomposite1
  libxcursor1
  libxdamage1
  libxfixes3
  libxi6
  libxrandr2
  libxrender1
  libxshmfence1
  libxcb-dri3-0
  libxkbcommon0
  libxss1
  libxtst6
  libsm6
  libice6
)

RENAMED_PACKAGES=(
  "libasound2t64 libasound2"
)

if command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

$SUDO apt-get update

RESOLVED_PACKAGES=("${BASE_PACKAGES[@]}")

for rename in "${RENAMED_PACKAGES[@]}"; do
  for candidate in $rename; do
    if apt-cache show "$candidate" >/dev/null 2>&1; then
      RESOLVED_PACKAGES+=("$candidate")
      break
    fi
  done
done
$SUDO apt-get install -y --no-install-recommends "${RESOLVED_PACKAGES[@]}"
$SUDO rm -rf /var/lib/apt/lists/*
