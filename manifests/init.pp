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

class pushing() {

	$message = 'Welcome to Pushing Puppet!'
	notify { 'welcome':
		message => "${message}",
	}
	file { '/root/WELCOME':
		content => "${message}\n",
	}

	# pull in the class that you want based on hostname...
	if "${::hostname}" =~ /^pushing(\d+)$/ {
		include "::pushing::${::hostname}"
	# is there something trailing after the lesson, eg: pushing8-a
	} elsif "${::hostname}" =~ /^pushing(\d+)/ {
	        $match = regsubst("${::hostname}", '^(pushing(\d+))([a-z\-]*)$', '\1')
		include "::pushing::${match}"
	}
}

# vim: ts=8
