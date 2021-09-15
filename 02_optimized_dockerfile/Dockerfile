FROM node:14-bullseye-slim
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
CMD ["node", "index.js"]
