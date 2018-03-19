FROM alpine

RUN apk add --no-cache bash nginx php5-fpm php5-cli php5-json php5-soap \
    && apk add --no-cache --virtual build-dependencies wget unzip \
    && wget --no-check-certificate https://github.com/phpvirtualbox/phpvirtualbox/archive/5.2-0.zip -O phpvirtualbox.zip \
    && unzip phpvirtualbox.zip -d phpvirtualbox \
    && mkdir -p /var/www \
    && mv -v phpvirtualbox/*/* /var/www/ \
    && rm phpvirtualbox.zip \
    && rm phpvirtualbox/ -R \
    && apk del build-dependencies

# config files
COPY config.php /var/www/config.php
COPY nginx.conf /etc/nginx/nginx.conf

# expose only nginx HTTP port
EXPOSE 80

# write linked instances to config, then monitor all services
CMD php-fpm5 && nginx
