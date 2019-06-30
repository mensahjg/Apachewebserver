##
# Default server configuration
#
server {
	listen 80;
	listen [::]:80;

	root /var/www/html;

	index index.php index.html index.htm index.nginx-debian.html;

	server_name ##DOMAIN_NAME##;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

	# pass PHP scripts to FastCGI server
	#
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
	
	 	# With php-fpm (or other unix sockets):
	 	fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
	 }

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	location ~ /\.ht {
		deny all;
	}
}

