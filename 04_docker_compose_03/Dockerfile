FROM node:14-bullseye-slim as base

FROM base as dev
RUN yarn global add nodemon
WORKDIR /opt/project

FROM base as prod
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --prod
COPY ./ ./
CMD ["node", "index.js"]

