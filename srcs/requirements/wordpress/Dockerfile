FROM debian:bullseye 

RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y  wget php7.4 \
	php7.4-fpm \
	php-mysql  \
	mariadb-client 


RUN wget  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp



RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /run/php

COPY tools/setup.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/html

EXPOSE 9000

RUN chown -R www-data:www-data /var/www/html 

ENTRYPOINT ["/usr/local/bin/setup.sh"]

