#!/usr/bin/awk -f

# Get CSV column by name
# Allan Clark - <napta2k@gmail.com>
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
