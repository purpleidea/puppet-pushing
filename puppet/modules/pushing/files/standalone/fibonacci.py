#!/usr/bin/python

# print a table of fibonacci numbers...

def F(n):
	if n == 0: return 0
	elif n == 1: return 1
	else: return F(n-1)+F(n-2)

import sys, time
start = time.time()
end = 5	# run as much as we can in approx 5 seconds max

for i in range(42):
	print "F(%d) == %d" % (i, F(i))
	if time.time() - start > end:
		sys.exit(1)

