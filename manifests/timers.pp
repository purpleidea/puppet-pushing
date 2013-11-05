
#
#	Timer example...
#

class pushing::timers(
	$again = true,
	$delta = 90	# 1.5 minutes
) {

	$logfile = '/tmp/timer.log'
	$timestamp = "(/bin/echo '    @ '`/bin/date`) >> ${logfile}"
	exec { 'start':
		command => "/bin/echo 'Start: Pushing Puppet is awesome!' > ${logfile} && ${timestamp}",
		creates => "${logfile}",
		notify => Runonce::Exec['runonce'],
	}

	runonce::exec { 'runonce':
		command => "/bin/echo 'Runonce: Run initial exec...' >> ${logfile} && ${timestamp}",
		require => Exec['start'],
	}

	runonce::timer { 'timer':
		command => "/bin/echo 'Timer: All done!' >> ${logfile} && ${timestamp}",
		repeat_on_failure => true,	# configurable...
		delta => $delta,	# time
		#again => true,	# default, uses: Exec['again'] with delta
		again => $again,
		require => [
			Exec['start'],
			Runonce::Exec['runonce'],
		],
	}
}

#
#	DRBD example
#

#	# bring resource up and start syncing
#	exec { "/sbin/drbdadm up ${resource}":
#		onlyif => "/sbin/drbdadm dstate ${resource} | /bin/awk -F '/' '{print $1}' | /bin/grep -E -q '(Unconfigured|Diskless)' && /bin/true TODO",
#		before => Service['drbd'],
#		notify => Runonce::Exec["drbd-initialsync-${resource}"],
#		require => [
#			Exec['modprobe-drbd'],
#			Exec["/sbin/drbdadm create-md ${resource}"],
#		],
#	}

#	# set initial sync rate to speed up initial deploy stage for cluster :)
#	runonce::exec { "drbd-initialsync-${resource}":
#		command => "/sbin/drbdadm disk-options --resync-rate=${initialrate} ${resource}",
#		require => [
#			Exec["/sbin/drbdadm up ${resource}"],
#		],
#	}

#	# wait an arbitrary amount of time for the initial sync and then revert
#	runonce::timer { "drbd-resetsync-${resource}":
#		command => "/sbin/drbdadm adjust ${resource}",
#		delta => 86400,	# 24h, an arbitrary guess
#		require => [	# added a few extra just in case we remove some
#			Runonce::Exec["drbd-initialsync-${resource}"],
#			Exec["/sbin/drbdadm up ${resource}"],
#		],
#	}

