class pushing::fibonacci::base {
	# TODO: i could use the proper $vardir, but /tmp/ is easier to clear
	# for demos...
	$vardir = '/tmp'
	file { "${vardir}/fibonacci/":
		ensure => directory,	# make sure this is a directory
		recurse => true,	# recurse into directory
		purge => false,		# don't purge unmanaged files
		force => false,		# don't purge subdirs and links
	}
}

