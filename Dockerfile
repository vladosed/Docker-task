FROM nginx:latest

COPY ./index.html /usr/share/nginx/html/index.html

COPY ./assets /usr/share/nginx/html/