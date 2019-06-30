# Nginxwebserver
Setup for WordPress, Nginx web server, and PHP

- ** Any assumptions made **

  1. Program will be run interactively by a user that has root or sudo access
  2. Firewall is assumed to be inactive
  3. Doc root is /var/www/html/wordpress
  4. sample.com file is in the same directory as the installer script
  5. FPM/FastCGI version is /etc/php/7.2/fpm 
  6. OS is Ubuntu

- ** Libraries you have used **
  nginx mysql-server php-fpm php-mysql unzip
  
- Instructions that explain how we can run/use your code.
1. Download installer.sh and sample.com to a directory on Ubuntu server
2. As root or a user with sudo access, run the the installer script
      e.g. ./installer.sh
3. You will be prompted to provide the domain name to be used
4. You will be prompt to setup MySQL root password and secure the database
5. A db user 'wpuser' will be created and granted all privileges to the wordpress database
6. A random password will be generated for the 'wpuser' account. This user password is stored in /var/www/html/wordpress/wp-config.php
