#!/bin/ksh

# $Id: splitpath.ksh,v 1.2 2007/09/23 00:08:27 napta2k Exp napta2k $

# File to search for
FILE=$1

# Original Internal Field Seperator (IFS)
O_IFS=$IFS

# Our path split/search function
splitpath()
{

 # Delimiter to split
 IFS=:

 # Main loop
 for i in $PATH
 do
  [[ -a $i/$FILE ]] && echo "$i/$FILE" && return 0
 done

 # Return IFS to original when finished
 IFS=$O_IFS

return 1
}

# Execute function
splitpath || print "Cannot find $FILE"
