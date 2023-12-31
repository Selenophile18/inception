#!/bin/sh
sleep 5
wp core download --path=/var/www/wordpress --allow-root
cd /var/www/wordpress
wp core config --dbhost=mariadb --dbname=$DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --allow-root
sed -i 's#listen = /run/php/php7.4-fpm.sock#listen = 0.0.0.0:9000#g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's#chdir = /var/www#chdir = /var/www/wordpress#g' /etc/php/7.4/fpm/pool.d/www.conf
wp core install --url=hhattaki.42.fr --title="joli 3lik" --admin_user=$ADMIN_USER \
	--admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL --allow-root
wp user create $USER --user_pass=$PASSWORD $EMAIL --role=author --allow-root

wp config set WP_REDIS_PORT "6379" --allow-root
wp config set WP_REDIS_HOST "redis" --allow-root
wp plugin install redis-cache --force --activate --allow-root
wp redis enable --allow-root
chown -R www-data:www-data /var/www/wordpress

php-fpm7.4 -F