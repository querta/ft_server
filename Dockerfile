# CLEAN: 	docker system prune -a -f
# BUILD 	docker build -t image .
# RUN		docker run -p 80:80 -p 443:443 --name ft_server image
# SHELL		docker exec -it ft_server /bin/bash

FROM debian:buster

RUN apt upgrade -y
RUN apt update
RUN apt install -y nginx
RUN apt install -y php-mysql php-fpm php-cgi
RUN apt install -y wget vim mariadb-server
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN wget https://ru.wordpress.org/latest-ru_RU.tar.gz
RUN mkdir /var/www/wp
RUN tar -xvf latest-ru_RU.tar.gz -C /var/www/wp --strip-components 1
RUN mkdir /var/www/pma
RUN tar -xvf phpMyAdmin-5.0.4-all-languages.tar.gz -C /var/www/pma --strip-components 1
RUN rm latest-ru_RU.tar.gz phpMyAdmin-5.0.4-all-languages.tar.gz

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/othercrt.pem -keyout /etc/nginx/ssl/othercrt.key -subj "/C=RU/ST=Moscow/L=Moscow/O=21 school/OU=Mmonte/CN=othercrt"

COPY /srcs/nginx.conf /etc/nginx/sites-available/nginx.conf
COPY /srcs/wp-config.php /var/www/wp/
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
RUN ln -s /var/www/wp /var/www/html/wp
RUN ln -s /var/www/pma /var/www/html/pma

RUN service mysql start  && echo "CREATE DATABASE wp;" | mysql -u root --skip-password && echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';" | mysql -u root --skip-password && echo "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password

RUN mkdir /var/www/pma/tmp
RUN chown -R www-data:www-data /var/www/
RUN chmod -R 755 /var/www/

EXPOSE 80 443

COPY /srcs/start.sh ./

CMD bash start.sh


