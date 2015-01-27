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

class pushing::pushing0() {

	# clean.sh
	# fibonacci.pp
	# fibonacci.py
	# fibonacci.sh
	file { '/root/standalone/':
		source => 'puppet:///modules/pushing/standalone/',
		owner => 'root',
		group => 'root',
		mode => 770,			# u=rwx,g=rwx
		backup => false,		# don't backup to filebucket
		ensure => present,
	}
}

# vim: ts=8
