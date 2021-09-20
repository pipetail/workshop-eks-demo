FROM node:14-bullseye-slim
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY ./ ./
CMD ["node", "index.js"]
