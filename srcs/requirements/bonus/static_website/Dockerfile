FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx

RUN rm -rf /var/lib/apt/lists/*

COPY Ghaith_CV/index.html /var/www/html/index.html
COPY Ghaith_CV/style.css /var/www/html/style.css

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

