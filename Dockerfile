FROM debian:buster

MAINTAINER cdelaby@student.s19.be

RUN apt-get update
RUN apt-get install -y nginx php7.3-fpm

COPY ./srcs/index.nginx-debian.html /var/www/html/index.nginx-debian.html
EXPOSE 80:80
CMD ["nginx", "-g", "daemon off;"]

