FROM node:18.8.0-alpine3.16 as builder
WORKDIR /app
COPY package*.json ./
COPY tsconfig*.json ./
COPY src src
COPY test test
RUN  npm ci && npm run build
RUN  npm run test:e2e

FROM node:18.8.0-alpine3.16
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY --from=builder /app/dist/ dist/
ENTRYPOINT ["npm", "run", "start:prod"]