#!/bin/bash

# simple bash script to iteratively run our local fibonacci code...

# TODO: clean
#rm -rf /tmp/fibonacci/

echo 'Running iterative fibonacci magic...'

count=0
substring='Notice: Script: '
while ! x=$(./fibonacci.pp | grep "$substring") ; do
	echo "looping($count)"
	count=$(($count+1))
done

l=${#substring}				# length of substring
ix=`expr index "$x" "$substring"`	# start of match
s=$(($ix+$l-1))				# start of result
echo "Puppet says: ${x:$s}"		# pretty print result

