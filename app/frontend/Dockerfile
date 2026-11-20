FROM node:22-alpine AS dependencies

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev


FROM node:22-alpine AS runtime

WORKDIR /app

RUN rm -rf /usr/local/lib/node_modules/npm \
           /usr/local/lib/node_modules/corepack \
           /opt/yarn-* \
    && rm -f /usr/local/bin/npm \
             /usr/local/bin/npx \
             /usr/local/bin/corepack \
             /usr/local/bin/yarn \
             /usr/local/bin/yarnpkg

COPY --chown=node:node . .
COPY --from=dependencies --chown=node:node /app/node_modules ./node_modules

USER node

EXPOSE 3000

CMD ["node", "server.js"]