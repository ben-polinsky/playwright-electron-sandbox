#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[run-playwright-tests] %s\n' "$*"
}

trap 'status=$?; log "Playwright test script exiting with status ${status}."' EXIT

log "Working directory: $(pwd)"
log "Node version: $(node -v)"
log "npm version: $(npm -v)"
if command -v electron >/dev/null 2>&1; then
  log "Electron binary: $(command -v electron)"
fi
if electron_version=$(node -p "require('electron/package.json').version" 2>/dev/null); then
  log "Electron version: ${electron_version}"
else
  log "Unable to resolve local electron package"
fi
if playwright_package_version=$(node -p "require('@playwright/test/package.json').version" 2>/dev/null); then
  log "@playwright/test version: ${playwright_package_version}"
else
  log "Unable to resolve local @playwright/test package"
fi
if playwright_cli_version=$(npx playwright --version 2>/dev/null); then
  log "Playwright CLI version: ${playwright_cli_version}"
else
  log "Unable to determine Playwright CLI version"
fi

log "CI environment: ${CI:-<unset>}"
log "DEBUG flags: ${DEBUG:-<unset>}"
log "ELECTRON_ENABLE_LOGGING: ${ELECTRON_ENABLE_LOGGING:-<unset>}"

if ! command -v xvfb-run >/dev/null 2>&1; then
  log "xvfb-run is required but not installed."
  exit 1
fi

XVFB_SERVER_ARGS="${XVFB_SERVER_ARGS:--screen 0 1280x720x24}"
log "Using xvfb-run server args: ${XVFB_SERVER_ARGS}"

PLAYWRIGHT_ARGS=("$@")
log "Invoking Playwright with args: ${PLAYWRIGHT_ARGS[*]:-<none>}"

log "Starting Playwright test run..."
if xvfb-run -a --server-args="${XVFB_SERVER_ARGS}" npx playwright test --reporter=line "${PLAYWRIGHT_ARGS[@]}"; then
  log "Playwright test run completed successfully."
else
  status=$?
  log "Playwright test run failed with exit code ${status}."
  exit "$status"
fi
