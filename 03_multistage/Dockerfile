FROM node:14-bullseye-slim AS builder
WORKDIR /app
COPY . .
RUN apt-get update \
	&& apt-get install -y \
		make \
		gcc \
		libsqlite3-dev \
		python
RUN yarn install

FROM node:14-bullseye-slim
WORKDIR /app
COPY --from=builder /app /app
CMD ["node", "index.js"]
