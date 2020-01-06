FROM debian:buster

MAINTAINER cdelaby@student.s19.be

RUN apt-get update
RUN apt-get install -y nginx php7.3-fpm
RUN apt-get install -y wget
RUN apt-get install -y mariadb-server
RUN apt-get install -y php7.3-mysql
#configure mysql 
#create creation script and pipe it into mysql
COPY ./srcs/sql.conf /tmp
RUN service mariadb start && cat /tmp/sql.conf | mariadb
#wget phpmyadmin
#tar -C /var/www/phpmyadmin xvf the .tar
#setup nginx
COPY ./srcs/nginx.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
RUN unlink /etc/nginx/sites-enabled/default
#setup phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-english.tar.gz
RUN tar -C /var/www -xvf phpMyAdmin-4.9.2-english.tar.gz
RUN mv /var/www/phpMyAdmin-4.9.2-english /var/www/phpMyAdmin
#copy wordpress
COPY ./srcs/wordpress /var/www
#adding ssl layer
COPY ./srcs/ssl.conf /tmp
RUN openssl req -x509 -nodes -days 365 -newkey -config /tmp/ssl.conf rsa:2048 -keyout /etc/nginx/nginx.key -out /etc/nginx/nginx.cert
EXPOSE 80
CMD service mariadb start && service php7.3-fpm start && nginx -g "deamon off" 
#CMD ["nginx", "-g","deamon off"]

