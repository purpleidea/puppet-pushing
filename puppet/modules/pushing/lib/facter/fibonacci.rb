# Pushing Puppet example Fibonacci code
# Copyright (C) 2012-2013+ James Shubin
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

require 'facter'

fibdir = '/tmp/fibonacci/'				# TODO: get from global
valid_fibdir = fibdir.gsub(/\/$/, '')+'/'		# ensure trailing slash

results = {}						# create list of values

if File.directory?(valid_fibdir)
	Dir.glob(valid_fibdir+'*').each do |f|
		b = File.basename(f)
		i = b.to_i		# invalid returns 0
		if b == '0' or i != 0
			# NOTE: i don't validate the opening of the file much !
			v = File.open(f, 'r').read.strip.to_i	# read into int
			results[i] = v
		else
			# TODO: warning, skip this invalid file...
		end

	end
end

results.keys.each do |x|
	Facter.add('pushing_fibonacci_'+x.to_s) do
		#confine :operatingsystem => %w{CentOS, RedHat, Fedora}
		setcode {
			results[x]
		}
	end
end

Facter.add('pushing_fibonacci_facts') do
	#confine :operatingsystem => %w{CentOS, RedHat, Fedora}
	setcode {
		results.keys.collect {|x| 'pushing_fibonacci_'+x.to_s}.join(',')
	}
end

