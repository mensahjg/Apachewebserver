#!/usr/bin/bash


#get site name
DisplayMenu ()
{
	clear
        /bin/echo -e "####################################################################"
        /bin/echo -e "#                                                                  #"
        /bin/echo -e "# Script to install Nginx, mySQL, Wordpress & PHP on Ubuntu server #"
        /bin/echo -e "# Usage: ./installer.sh ;                                          #" 
        /bin/echo -e "#                                                                  #"
        /bin/echo -e "####################################################################"
	/bin/echo -e -n "\nEnter domain name to be used for the site. e.g. (mysite.com) :>  "
}

DisplayMenu
read domainname

#validate domainname
if [ -z $domainname  ] ; then
	 echo -e "\nInvalid domain name entered"; exit 1
fi


#install updates and packages
sudo apt update
sudo apt install nginx mysql-server php-fpm php-mysql unzip -y

fw_status=`sudo ufw status | grep 'Status:' | cut -d" " -f2`

if [ $fw_status == 'active' ] ; then
	sudo ufw allow 'Nginx HTTP'
fi

# Create a /etc/hosts entry for domain name pointing to localhost
hostentry=`grep $domainname /etc/hosts`

if [ -z "$hostentry" ] ; then
	sudo sed -i "s/localhost/localhost $domainname/" /etc/hosts
fi


# Create an nginx config file for the domain
if [ -f ./sample.com ] ; then 
	sudo cp sample.com /etc/nginx/sites-available/$domainname
	sudo sed -i "s/##DOMAIN_NAME##/$domainname/" /etc/nginx/sites-available/$domainname
	sudo ln -sf /etc/nginx/sites-available/$domainname /etc/nginx/sites-enabled/default
else
	echo -e "\nERROR: Missing file sample.com. Please download from repo https://github.com/mensahjg/nginxwebserver and rerun script"
	exit 1
fi

# Download Wordpress to /var/www/html/
wget  http://wordpress.org/latest.zip 

if [ -f ./latest.zip ] ; then
	sudo unzip -o ./latest.zip -d /var/www/html/ && rm -f ./latest.zip 
fi

# configure MySQL root password
sudo mysql_secure_installation

# Create new Mysql database for WordPress
echo -e "\n#############################################################\n"
echo -n "Please enter the MySQL root password :>  "
read -s mysqlpasswd


MAINDB=`echo ${domainname} | tr -d '.'`
MAINDB=${MAINDB}_db
user='root'
# create random password
PASSWD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};echo;`
echo -e "\nCreating database ${MAINDB} for WordPress"
MYSQL_PWD=$mysqlpasswd sudo mysql -u $user -e "CREATE DATABASE ${MAINDB};"
echo -e "\nCreating wordpress user 'wpuser'"
MYSQL_PWD=$mysqlpasswd sudo mysql -u $user -e "CREATE USER wpuser@localhost IDENTIFIED BY '${PASSWD}';"
MYSQL_PWD=$mysqlpasswd sudo mysql -u $user -e "GRANT ALL ON ${MAINDB}.* TO 'wpuser'@'localhost';"
MYSQL_PWD=$mysqlpasswd sudo mysql -u $user -e "FLUSH PRIVILEGES;"


# Create a wp-config.php with proper DB configuration

sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

sudo sed -i "s/database_name_here/$MAINDB/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/wpuser/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/$PASSWD/" /var/www/html/wordpress/wp-config.php

echo "Password generated for wordpress db user 'wpuser' can be found in /var/www/html/wordpress/wp-config.php"
echo "restarting Nginx service"
sudo systemctl reload nginx

echo -e "\nWordpress site should be available at http://${domainname}. Please open in browser."
