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

# README: this is a module built for use with: Oh My Vagrant!

class pushing::pushing8() {
	$max_pokes = 8

	# FIXME: list of ['a', 'b', 'c'] should be dynamic...
	$hosts = suffix(prefix(['a', 'b', 'c'], 'pushing8-'), 'example.com')
	$index = inline_template("<%= @hosts.index('${::hostname}') %>")
	$count = count($hosts)
	if ($count <= 0) {
		fail('Need at least one host to continue!')
	}
	if ($count == 1) {
		warning('Only one host is in the poke ring.')
	}
	# wrap around and form a loop
	$plus1 = inline_template("<%= (@index.to_i >= @count) ? 0 : (@index.to_i+1) %>")
	$next1 = values_at($hosts, $plus1)	# next in list...

	class { '::common::counter':
	}

	# NOTE: we only see the notify message. no other exec/change is shown!
	notify { 'counter':
		message => "Counter is: ${::common_counter_simple}",
	}

	include poke::listen

	# poke in a circular ring until $max_pokes
	poke { "${next1}":
	}

	exec { "/bin/echo running poke #: ${::common_counter_simple}":
		logoutput => on_failure,
		# set a maximum length for the circular ring...
		onlyif => [
			"/usr/bin/test ${::common_counter_simple} -lt ${max_pokes}",
			"/usr/bin/test ${::common_counter_simple} -gt 0",
		],
		notify => Poke["${next1}"],
	}
}

# vim: ts=8
