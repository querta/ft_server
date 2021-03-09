service mysql start
service php7.3-fpm start
printf "Server started\n"
nginx -g 'daemon off;'
bash