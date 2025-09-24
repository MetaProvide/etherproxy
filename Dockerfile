FROM node:24-alpine AS base

# build
FROM base AS build
WORKDIR /usr/src/app
COPY . .

RUN npm ci
RUN npm run build
RUN npm prune --production

# run
FROM base AS run
WORKDIR /usr/src/app

COPY --from=build --chown=nobody:nogroup /usr/src/app/dist dist
COPY --from=build --chown=nobody:nogroup /usr/src/app/node_modules node_modules
USER nobody
EXPOSE 9000

ENTRYPOINT [ "node", "dist/index.js"]
