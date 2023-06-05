FROM node:16 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM nginx:1-alpine-slim
ARG STAGE=production
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=build /app/.deploy/${STAGE}/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]