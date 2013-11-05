#
#	Exec['again']
#
class custom::again(
) {
	include common::again

	file { '/tmp/foo':
		content => "Something happened!\n",
		# NOTE: that as long as you don't remove or change the /tmp/foo file,
		# this will only cause a notify when the file needs changes done. This
		# is what prevents this from infinite recursion, and lets puppet sleep.
		notify => Exec['again'],	# notify puppet!
	}

	# always exec so that i can easily see when puppet runs... proof that it works!
	exec { 'proof':
		command => '/bin/date >> /tmp/puppet.again',
	}
}

#
#	Fibonacci
#
class custom::fibonacci(
) {

	# kick it off...
	pushing::fibonacci { 'start':
		n => 8,
		script => true,
	}

}

#
#	Timers
#
class custom::timers1(
) {

	class { 'pushing::timers':
		again => false,
	}

}

class custom::timers2(
) {

	class { 'pushing::timers':
		again => true,	# the default (use Exec['again'] with delta)
	}

}

#
#	FSM
#
class custom::fsm(
	$start = 'start'	# hiera !
) {
	#include ::fsm		# the two leading colons (::) are vital!
	fsm::transition { 'water':
		input => 'liquid',
		#input => 'solid',
		#input => 'gas',
		#input => 'liquid',
		#input => 'solid',
		#input => 'gas',
		#input => 'plasma',
		#input => 'gas',
		#chain_maxlength => 4,
	}

#	fsm::transition { 'hydrogen':
#		#input => 'liquid',
#		#input => 'gas',
#		#input => 'plasma',
#		input => 'gas',
#	}
}

