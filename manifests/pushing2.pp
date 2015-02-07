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

class pushing::pushing2() {

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

# vim: ts=8
