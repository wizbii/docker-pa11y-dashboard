FROM alpine/git AS build_git
RUN git clone https://github.com/pa11y/pa11y-dashboard.git /app

FROM node:14 AS build_node
COPY --from=build_git /app /app
WORKDIR /app
RUN cd /app; \
    npm install;

FROM buildkite/puppeteer
COPY --from=build_node /app /app

ENV NODE_ENV=production

ADD ./config/config.json /app/config/production.json

WORKDIR /app

RUN npm install

CMD ["node", "index.js"]
