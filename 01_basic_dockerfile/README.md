## start the project

```bash
npm install -g yarn
npm init
yarn add express winston express-winston --save
```

## snippets

1. https://expressjs.com/en/starter/hello-world.html
2. https://www.npmjs.com/package/express-winston

## docker artifacts

```dockerfile
FROM node:14-bullseye-slim
```

## build

```bash
docker build -t 859133351452.dkr.ecr.eu-west-1.amazonaws.com/backend:v0.0.1 --platform linux/amd64 .
```

