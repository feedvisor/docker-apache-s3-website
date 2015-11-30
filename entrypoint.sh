#!/bin/sh

cat << EOF > /etc/apache2/sites-enabled/feedvisor-com.conf
<VirtualHost *:80>
        ServerName $VHOST_NAME
        ServerAlias www.$VHOST_NAME

        DocumentRoot /opt/$VHOST_NAME/www

        <Directory /opt/$VHOST_NAME/www>
                Options FollowSymLinks
                AllowOverride All
                Require all granted
        </Directory>
</VirtualHost>
EOF

mkdir -p /opt/$VHOST_NAME/www

aws s3 cp s3://$ENV_BUCKET/website/website.tgz /opt/$VHOST_NAME/

tar -xf /opt/$VHOST_NAME/website.tgz -C /opt/$VHOST_NAME/www

chown -R www-data:www-data /opt/$VHOST_NAME/www

apachectl start

tail -f /var/log/apache2/*
