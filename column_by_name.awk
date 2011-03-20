#!/usr/bin/awk -f

# Get an arbitrary CSV column by name
# Allan Clark - http://github.com/ajclark/scripts/
# 2010-12-04

# Usage: ./column_by_name.awk -v col=foo filename.csv

BEGIN {
	FS=","
}

NR == 1 {
	for (i=1; i<=NF; i++) {
		if ($i == col) {
			break
		}
	}
}

{ 
	print $i 
}


# Only want the final record?
END {
	print "Final record: " $i
}
