# syntax=docker/dockerfile:1
# Expects a pre-built Vite output directory (npm run build → ./build).
# CI uploads this folder from the build job; for local builds run `npm run build` first.

FROM nginx:1.31-alpine

COPY build/ /usr/share/nginx/html/

COPY <<'NGINX' /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
}
NGINX

EXPOSE 80

# Run nginx process in foreground so container can stay running: -g deamon off;
CMD ["nginx", "-g", "daemon off;"]
