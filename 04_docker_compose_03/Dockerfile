FROM node:14-bullseye-slim as base

FROM base as dev
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
CMD ["yarn", "run", "nodemon", "index.js"]

FROM base as prod
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --prod
COPY ./ ./
CMD ["node", "index.js"]

