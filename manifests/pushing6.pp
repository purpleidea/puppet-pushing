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

class pushing::pushing6(
	$type = '',
	$input = ''
) {

	fsm::transition { "${type}":
		input => "${input}",
	}

	#include ::fsm		# the two leading colons (::) are vital!
	#fsm::transition { 'water':
		#input => 'liquid',
		#input => 'solid',
		#input => 'gas',
		#input => 'liquid',
		#input => 'solid',
		#input => 'gas',
		#input => 'plasma',
		#input => 'gas',
		#chain_maxlength => 4,
	#}

#	fsm::transition { 'hydrogen':
#		#input => 'liquid',
#		#input => 'gas',
#		#input => 'plasma',
#		input => 'gas',
#	}

}

# vim: ts=8
