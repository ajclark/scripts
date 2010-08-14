#!/bin/bash

# Title: Add web user
# Author: Allan Clark - <napta2k@gmail.com>
# Date: 2008-07-07 
#
# Comment:
# 	This script will automate the process of adding a virtual host
#	to Apache and ProFTPD. SSH access is disallowed. 
#
# Apache:
# 	An Apache VirtualHost is created for the site, and the public_html and cgi-bin directories are
# 	copied from /etc/skel. The user is setup with a 'nologin' shell to prevent SSH access.
#
# ProFTPD:
# 	Your ProFTPD configuration should contain the DefaultRoot ~ and RequireValidShell Off directives.
# 	This will allow the user to access FTP via 'nologin' - but not SSH. 
# 	In general just use SSH keys with passphrases!

ADMIN=napta2k@gmail.com
WWW_GROUP=www-data
WWW_HTDOCS=/data/htdocs
WWW_VHOST_FILE=/etc/apache2/sites-available

if [ $# -ne 2 ]; then
   echo "Usage:"
   echo "$0 user-name my-site.com"
   exit 1
fi

# Create web user
echo "Creating web user: $1 with home dir: $2..."
useradd -g $WWW_GROUP -d ${WWW_HTDOCS}/${2} -s /sbin/nologin $1

# Set passwd for web user (interactive)
echo "Enter password for web user: $1"
passwd $1

# Copy skel files for web user
echo "Copying skel information for web user: $1"
cp -rp /etc/skel/ ${WWW_HTDOCS}/${2}

# Set permissions for web user
echo "Setting directory permissions on: $2" 
chown -R ${1}:${WWW_GROUP} ${WWW_HTDOCS}/${2}
chmod -R 750 ${WWW_HTDOCS}/${2}

# Write vhost configuration out to apache
echo "Creating apache Virtual Host configuration..."
cat << EOF > ${WWW_VHOST_FILE}/${2}
<VirtualHost *:80>
   ServerName $2
   ServerAlias www.${2}
   DocumentRoot ${WWW_HTDOCS}/${2}/public_html
   ScriptAlias /cgi-bin/ ${WWW_HTDOCS}/${2}/cgi-bin
</VirtualHost>
EOF

# Add virtual host to apache 'sites-enabled' 
echo "Adding virtual host to sites-enabled..."
ln -s /etc/apache2/sites-available/${2} /etc/apache2/sites-enabled/${2}

# Mail alert that new user / virtual host has been created
cat << EOF | mail -s "${0}: New user created on: $(hostname)" $ADMIN
   A new web user has been created on the server: $(hostname).
   Username: $1
   VirtualHost: $2
EOF

# Finished
echo "New web user created. Please run /etc/init.d/apache2 restart for settings to take effect."
