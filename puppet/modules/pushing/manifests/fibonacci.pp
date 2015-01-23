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

#def F(n):
#	if n == 0: return 0
#	elif n == 1: return 1
#	else: return F(n-1)+F(n-2)

# kick it off...
#pushing::fibonacci { 'start':
#	n => 8,
#	script => true,
#}

define pushing::fibonacci(
	$n,
	$intermediate = false,		# only print the result
	$script = false			# print a script notify
) {
	include common::again
	include pushing::fibonacci::base
	$vardir = $pushing::fibonacci::base::vardir
	$fibdir = "${vardir}/fibonacci"

	if "${n}" == '0' {
		# 0
		#file { "${fibdir}/0":
		#	content => "0\n",
		#}
		exec { "${name}: F(0)":
			command => "/bin/echo 0 > ${fibdir}/0",
			creates => "${fibdir}/0",
			require => File["${vardir}/fibonacci/"],
		}

	} elsif "${n}" == '1' {
		# 1
		#file { "${fibdir}/1":
		#	content => "1\n",
		#}
		exec { "${name}: F(1)":
			command => "/bin/echo 1 > ${fibdir}/1",
			creates => "${fibdir}/1",
			require => File["${vardir}/fibonacci/"],
		}

	} else {

		$minus1 = inline_template('<%= n.to_i - 1 %>')
		pushing::fibonacci { "${name}: F(${n}-1)":
			n => $minus1,
			intermediate => true,
		}

		$minus2 = inline_template('<%= n.to_i - 2 %>')
		pushing::fibonacci { "${name}: F(${n}-2)":
			n => $minus2,
			intermediate => true,
		}

		# these are 'fact' lookups
		$fn1 = getvar("pushing_fibonacci_${minus1}")
		$fn2 = getvar("pushing_fibonacci_${minus2}")

		if (("${fn1}" == '') or ("${fn2}" == '')) {
			$fn = ''
		} else {
			$fn = inline_template('<%= fn1.to_i+fn2.to_i %>')
		}

		if "${fn}" != '' {	# did the lookup work ?
			# store fibonacci number in 'table'
			exec { "${name}: F(${n})":
				command => "/bin/echo ${fn} > ${fibdir}/${n}",
				creates => "${fibdir}/${n}",
				require => [
					File["${vardir}/fibonacci/"],
					Pushing::Fibonacci["${name}: F(${n}-1)"],
					Pushing::Fibonacci["${name}: F(${n}-2)"],
				],
			}

			# are we ready to display the final result ?
			if ! $intermediate {
				notify { "F(${n})":
					message => "F(${n}) == ${fn}",
					require => Exec["${name}: F(${n})"],
				}
				if $script {
					notify { "Script: F(${n})":
						message => "Script: F(${n}) == ${fn}",
						require => Exec["${name}: F(${n})"],
					}
				}
			}
		}
		# else {
		#	# Exec['again']

		# ensure we notify puppet to go again whenever a fact is needed
		exec { "${name}: notify":
			command => '/bin/true',	# noop :P
			onlyif => "${fn}" ? {
				'' => '/bin/true',
				default => '/bin/false',
			},
			notify => Exec['again'],	# notify puppet!
		}
		#}
	}
}

# vim: ts=8
