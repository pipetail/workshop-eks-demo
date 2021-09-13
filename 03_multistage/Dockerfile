FROM node:16.8.0-bullseye
COPY . .
RUN apt-get update \
	&& apt-get install -y \
		make \
		gcc \
		libsqlite3-dev \
		python
RUN yarn install
CMD ["node", "index.js"]
