# Pushing Puppet, Oh My Vagrant module by James
# Copyright (C) 2013-2015+ James Shubin
# Written by James Shubin <james@shubin.ca>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

# vim: ts=8
