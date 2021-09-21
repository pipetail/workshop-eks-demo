FROM node:14-bullseye-slim
USER node
WORKDIR /opt/project
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
CMD ["node", "index.js"]
