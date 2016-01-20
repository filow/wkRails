FROM nginx
ADD rproxy-nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
