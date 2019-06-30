#!/usr/bin/bash

#get site name
DisplayMenu ()
{
	clear
        /bin/echo -e "###################################################################"
        /bin/echo -e "#\n# Script to install Nginx, mySQL and PHP on Ubuntu server vers 1.x #"
        /bin/echo -e "#\n###################################################################"
	/bin/echo -e -n "\nEnter domain name to be used for the site. e.g. (mysite.com) :>  "
}

DisplayMenu
read domainname

#validate domainname

#install updates and packages
sudo apt update
sudo apt install nginx mysql-server php-fpm php-mysql -y

fw_status=`sudo ufw status | grep 'Status:' | cut -d" " -f2`

if [ $fw_status == 'active' ] ; then
	sudo ufw allow 'Nginx HTTP'
fi

# Create a /etc/hosts entry for domain name pointing to localhost
hostentry=`grep $domainname /home/jake/hosts`

if [ -z "$hostentry" ] ; then
	sudo sed -i "s/localhost/localhost $domainname/" /home/jake/hosts
fi



echo "firewall status is $fw_status"


# Create an nginx config file for the domain
if [ -f ./sample.com ] ; then 
	sudo cp sample.com /etc/nginx/sites-available/$domainname
	sudo sed -i "s/##DOMAIN_NAME##/$domainname/" /etc/nginx/sites-available/$domainname
else
	echo "Missing file sample.com. Please download from repo https://github.com/mensahjg/nginxwebserver and rerun script"
	exit 1
fi
#sudo mysql_secure_installation
