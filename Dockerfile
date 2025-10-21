# Use the official Playwright base image which ships with Node.js and browser dependencies
FROM mcr.microsoft.com/playwright:v1.44.1-jammy

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      xvfb \
      dbus-x11 \
      libasound2 \
      libatk1.0-0 \
      libatk-bridge2.0-0 \
      libatspi2.0-0 \
      libcairo2 \
      libcups2 \
      libdrm2 \
      libgbm1 \
      libglib2.0-0 \
      libgtk-3-0 \
      libnss3 \
      libpango-1.0-0 \
      libpangocairo-1.0-0 \
      libxcomposite1 \
      libxcursor1 \
      libxdamage1 \
      libxfixes3 \
      libxi6 \
      libxrandr2 \
      libxrender1 \
      libxshmfence1 \
      libxcb-dri3-0 \
      libxkbcommon0 \
      libxss1 \
      libxtst6 \
      libsm6 \
      libice6 && \
    rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json* ./

RUN if [ -f package-lock.json ]; then npm ci; else npm install --no-audit --no-fund; fi

COPY . .

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV CI=true

CMD ["xvfb-run", "-a", "npx", "playwright", "test"]
