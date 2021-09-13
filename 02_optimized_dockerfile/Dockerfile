FROM node:16.8.0-bullseye
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
CMD ["node", "index.js"]
