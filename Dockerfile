FROM debian:buster

MAINTAINER cdelaby@student.s19.be

RUN apt-get update
RUN apt-get install -y nginx php7.3-fpm
RUN apt-get install -y wget
RUN apt-get install -y php7.3-mysql
RUN apt-get install -y mariadb-server
RUN apt-get install -y openssl
#configure mysql 
#create creation script and pipe it into mysql
COPY ./srcs/sql.conf /tmp
RUN service mysql start && cat /tmp/sql.conf | mysql
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
COPY ./srcs/wordpress /var/www/wordpress
#adding ssl layer
COPY ./srcs/ssl.conf /tmp
RUN openssl req -x509 -newkey rsa:2048 -nodes -config /tmp/ssl.conf -keyout /etc/nginx/nginx.key -out /etc/nginx/nginx.cert
CMD service mysql start && service php7.3-fpm start && nginx "-g daemon off;" 
#CMD ["nginx", "-g","deamon off"]
