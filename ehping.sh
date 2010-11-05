#!/bin/sh

# Lighttpd local restarter
# This restarts lighttpd in the event of a weird PHP-FCGI hang
# 2008-05-07 Allan Clark - <napta2k@gmail.com>

if [ -z $1 ]; then
    echo "Usage: $0 www.example.com"
    exit 1
fi

# Check site, timeout 1 second
wget -q -T 1 --tries 1 -O - $1 > /dev/null

# Site is down, attempt to stop lighttpd
if [ $? != 0 ]; then
    /etc/init.d/lighttpd stop

# If graceful shutdown fails, send SIGKILL
    pgrep lighttpd
    if [ $? == 0 ]; then
        pkill -9 lighttpd
    fi

# Repeat for PHP fastcgi processes
    pgrep php5-cgi
    if [ $? == 0 ]; then
        pkill -9 php5-cgi
    fi

# Start lighttpd again
    /etc/init.d/lighttpd start

# Mail admin
    echo "${1} was restarted by ${0}" | mail -s "${1} was restarted by ${0}" napta2k@gmail.com
fi

