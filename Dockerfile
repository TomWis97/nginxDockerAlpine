FROM alpine:latest
# Install Nginx
RUN apk update && \
    apk add nginx && \
    chown nginx:nginx -R /var/log/nginx && \
    mkdir /run/nginx && \
    chown nginx:nginx /run/nginx && \
    mkdir /var/cache/nginx && \
    chown nginx:nginx /var/cache/nginx && \
    echo 'daemon off;' >> /etc/nginx/nginx.conf && \
    sed -i 's/user nginx;//' /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/
ADD index.php /usr/share/nginx/html/
# Install PHP
RUN apk update && \
    apk add php7 php7-fpm && \
    mkdir -p /var/run/php-fpm && \
    chown -R nginx:nginx /var/run/php-fpm && \
    chown -R nginx:nginx /var/log
ADD www.conf /etc/php7/php-fpm.d/www.conf
# Install supervisor
RUN apk update && \
    apk add supervisor
ADD www.conf /etc/php7/php-fpm.d/www.conf
ADD supervisord.conf /etc/supervisord.conf
EXPOSE 8080
USER nginx
CMD supervisord -c /etc/supervisord.conf
