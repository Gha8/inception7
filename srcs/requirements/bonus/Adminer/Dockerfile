FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	php-cli \
	php-mysqli \
	wget 

RUN rm -rf /var/lib/apt/lists/*

COPY ./tools/adminer.php /var/www/html/adminer.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080","-t", "/var/www/html"]
