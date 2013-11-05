#!/usr/bin/puppet apply

define recursion(
	$count
) {
	notify { "count-${count}":
	}
	$minus1 = inline_template('<%= count.to_i - 1 %>')
	if "${minus1}" == '0' {
		notify { 'done counting!':
		}
	} else {
		# recurse
		recursion { "count-${minus1}":
			count => $minus1,
		}
	}
}

# kick it off...
recursion { 'start':
	count => 42,
}

