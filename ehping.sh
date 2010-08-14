#!/bin/sh

# TODO:
#   - Remove dependency on check_http(1) binary

if [ -z $1 ]; then
    echo "Usage: $0 www.example.com [/index.html]"
    exit 1
fi

if [ -z $2 ]; then
    ARGS="-H ${1}"
else
    ARGS="-H $1 -u ${2}"
fi

# check_http, stolen from Nagios
/root/scripts/check_http $ARGS

if [ $? != 0 ]; then
    /etc/init.d/lighttpd stop
    pgrep lighttpd
    if [ $? == 0 ]; then
        pkill -9 lighttpd
    fi
    pgrep php5-cgi
    if [ $? == 0 ]; then
        pkill -9 php5-cgi
    fi
    /etc/init.d/lighttpd start
    echo "${1} was restarted by ${0}" | mail -s "${1} was restarted by ${0}" napta2k@gmail.com
fi

