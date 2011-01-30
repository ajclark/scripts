#!/bin/sh

# Masterless Puppet deployment script
# Written by Allan Clark - <napta2k@gmail.com>
# 2008-06-07

DEFAULT_ROLE=common
PUPPET_PATH=/Users/napta2k/Code/puppet

# Print usage
if [ -z "$1" ]; then
	echo "You must specify a server."
	echo "Usage: ${0} <server> [role] (role defaults to common)"
	echo "Usage: ${0} --all [role] (role defaults to common)"
	exit 1
fi

# Deploy puppet role to all servers (svr[1-3].st0len.co.za)
if [ "$1" == "--all" ]; then
	for i in {1..3} 
		do
       		printf "svr${i}.st0len.co.za ...\n"
		rsync -avz --delete puppet svr${i}.st0len.co.za:/home/napta2k/ 1>/dev/null
		ssh svr${i}.st0len.co.za "sudo puppet -v /home/napta2k/puppet/modules/${2-$DEFAULT_ROLE}/init.pp"
		done
	exit 0
fi

# Deploy puppet role to a single server
rsync -avz --delete $PUPPET_PATH ${1}:/home/napta2k/ 1>/dev/null

# Execute puppet
ssh ${1} "sudo puppet -v /home/napta2k/puppet/modules/${2-$DEFAULT_ROLE}/init.pp"
