# Playwright Electron Sandbox

This repository contains a proof-of-concept Electron application with end-to-end tests written in Playwright. The tests are intended to run inside a Linux Docker container, making it easy to validate Electron builds in containerized CI environments.

## Project Structure

```text
.
├── Dockerfile               # Container image used to run the Playwright tests
├── package.json             # npm metadata, scripts, and dev dependencies
├── playwright.config.js     # Playwright test runner configuration
├── renderer/                # Static assets rendered in the Electron BrowserWindow
├── src/                     # Electron main process source files
└── tests/                   # Playwright E2E tests that automate the Electron app
```

## Getting Started Locally

```bash
npm install
npm run start
```

The default window renders a friendly message and exposes a small preload script for testing.

Run the Playwright tests locally (they will automatically be wrapped in `xvfb-run` to provide a virtual display on Linux):

```bash
npm test
```

> **Note:** On Debian/Ubuntu based distributions you may need to install additional system packages for Electron (for example: `apt-get install -y xvfb libgtk-3-0 libnss3 libxss1 libatk1.0-0 libatk-bridge2.0-0 libcups2 libasound2`). On Ubuntu 24.04 and newer t64-based releases the packages `libgtk-3-0`, `libatk1.0-0`, `libatk-bridge2.0-0`, `libcups2`, and `libasound2` are provided under their `*-t64` names instead; our CI workflow installs whichever variant is available.

To watch the tests interact with the UI, run them in headed mode:

```bash
npm run test:headed
```

## Running Inside Docker

The included `Dockerfile` builds on top of the official Playwright image so that all browser dependencies are preinstalled. Build the image and run the tests:

```bash
docker build -t playwright-electron-sandbox .
docker run --rm playwright-electron-sandbox
```

The container will execute `npm ci` to install dependencies and then run the Playwright suite inside a virtual frame buffer so Electron can render without a physical display.

## Continuous Integration

A GitHub Actions workflow (`.github/workflows/ci.yml`) checks out the repository, installs the required system dependencies for Electron, runs `npm ci`, and executes `npm test`. The workflow runs on pushes to `main` and on pull requests so every change is validated automatically.

## Extending the Example

- Add additional windows or renderer code under `renderer/` and corresponding logic in `src/`.
- Write more Playwright specs in the `tests/` directory to cover new behaviors.
- Integrate the `Dockerfile` or provided GitHub Actions workflow with your CI provider of choice to validate Electron releases in a reproducible environment.
