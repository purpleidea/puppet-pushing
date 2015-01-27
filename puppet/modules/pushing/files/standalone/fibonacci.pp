#!/usr/bin/puppet apply

#def F(n):
#	if n == 0: return 0
#	elif n == 1: return 1
#	else: return F(n-1)+F(n-2)

class fibonacci::base {
	$vardir = '/tmp'
	file { "${vardir}/fibonacci/":
		ensure => directory,	# make sure this is a directory
		recurse => true,	# recurse into directory
		purge => false,		# don't purge unmanaged files
		force => false,		# don't purge subdirs and links
	}
}

define fibonacci(
	$n,
	$intermediate = false,		# only print the result
	$script = false			# print a script notify
) {
	include fibonacci::base
	$vardir = $fibonacci::base::vardir
	$fibdir = "${vardir}/fibonacci"

	if "${n}" == '0' {
		# 0
		#file { "${fibdir}/0":
		#	content => "0\n",
		#}
		exec { "${name}: F(0)":
			command => "/bin/echo 0 > ${fibdir}/0",
			creates => "${fibdir}/0",
			require => File["${fibdir}/"],
		}

	} elsif "${n}" == '1' {
		# 1
		#file { "${fibdir}/1":
		#	content => "1\n",
		#}
		exec { "${name}: F(1)":
			command => "/bin/echo 1 > ${fibdir}/1",
			creates => "${fibdir}/1",
			require => File["${fibdir}/"],
		}

	} else {

		$minus1 = inline_template('<%= @n.to_i - 1 %>')
		fibonacci { "${name}: F(${n}-1)":
			n => $minus1,
			intermediate => true,
		}

		$minus2 = inline_template('<%= @n.to_i - 2 %>')
		fibonacci { "${name}: F(${n}-2)":
			n => $minus2,
			intermediate => true,
		}

		# this is cheating because it's not using a puppetmaster
		# who can figure out what the problem with this is ?

		#$fn = inline_template('<%= f1=@fibdir+"/"+@minus1; f2=@fibdir+"/"+@minus2; ((File.exist?(f1) and File.exist?(f2)) ? (File.open(f1, "r").read.to_i + File.open(f2, "r").read.to_i) : -1) %>')
		# split into two version:
		$fn1 = inline_template('<%= f1=@fibdir+"/"+@minus1; (File.exist?(f1) ? File.open(f1, "r").read.to_i : -1) %>')
		$fn2 = inline_template('<%= f2=@fibdir+"/"+@minus2; (File.exist?(f2) ? File.open(f2, "r").read.to_i : -1) %>')

		if (("${fn1}" == '-1') or ("${fn2}" == '-1')) {
			$fn = '-1'
		} else {
			$fn = inline_template('<%= @fn1.to_i+@fn2.to_i %>')
		}

		if "${fn}" != '-1' {	# did the lookup work ?
			# store fibonacci number in 'table'
			exec { "${name}: F(${n})":
				command => "/bin/echo ${fn} > ${fibdir}/${n}",
				creates => "${fibdir}/${n}",
				require => [
					File["${fibdir}/"],
					Fibonacci["${name}: F(${n}-1)"],
					Fibonacci["${name}: F(${n}-2)"],
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
		} else {
			# Exec['again']	# TODO
		}
	}
}

# kick it off...
fibonacci { 'start':
	n => 8,
	script => true,
}

