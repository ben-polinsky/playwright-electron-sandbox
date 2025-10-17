# Use the official Playwright base image which ships with Node.js and browser dependencies
FROM mcr.microsoft.com/playwright:v1.44.1-jammy

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends xvfb && \
    rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json* ./

RUN if [ -f package-lock.json ]; then npm ci; else npm install --no-audit --no-fund; fi

COPY . .

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

CMD ["xvfb-run", "-a", "npx", "playwright", "test"]
