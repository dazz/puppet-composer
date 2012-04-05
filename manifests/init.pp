class composer {
	
	include composer::params
	
	# trage werte in die php.ini ein
	#  set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
#	augeas{"whitelist_phar" :
#    context => "/files/etc/php5/conf.d/suhosin.ini/suhosin",
#    changes => "set suhosin.executor.include.whitelist phar",
##    onlyif  => "match other_value size > 0",
#  }
#  
#  augeas{"allow_url_fopen" :
#    context => "/files/etc/php5/cli/php.ini",
#    changes => "set allow_url_fopen On",
##    onlyif  => "match other_value size > 0",
#  }
  
#  augeas { "default php.ini settings":
#    context => "/files/${phpini}",
#    changes => [
#      "set PHP/set allow_url_fopen On",
#    ],
#    notify => Service["apache"],
#  }
#   
	# download composer
	exec { "download_composer":
#		command  => "${composer::params::exec_download} /usr/local/src/ ",
		command => "curl -s http://getcomposer.org/installer | php",
		require => Package["php5-cli"],
		logoutput => true,
		creates => "/usr/local/src/composer.phar",
#		onlyif   => "composer",
	}
	
	# copy composer.phar to /usr/local/src/
	file { "/usr/local/src/composer.phar":
    ensure => present,
    source => "/tmp/vagrant-puppet/manifests/composer.phar",
  }
	
	# delete copy composer.phar to 
	file { "/tmp/vagrant-puppet/manifests/composer.phar":
    ensure => absent,
    force  => true,
  }
	
	
	
	
	# download composer
	#file {"/etc/php5/conf.d/composer.ini":
#	 source    => "http://getcomposer.org/composer.phar",
#	 target => "/usr/local/src/composer.phar", #"${composer::params::target_dir}/",
	 #ensure  => "present",
	 #content => "suhosin.executor.include.whitelist = phar\n allow_url_fopen = On",
	#}
	
#	vagrant@vagrant-debian-squeeze:~$ curl -s http://getcomposer.org/installer | php                                              #!/usr/bin/env php
#  Some settings on your machine make Composer unable to work properly.
#  Make sure that you fix the issues listed below and run this script again:
#
#  The suhosin.executor.include.whitelist setting is incorrect.
#  Add the following to the end of your `php.ini`:
#    suhosin.executor.include.whitelist = phar
#
#  The allow_url_fopen setting is incorrect.
#  Add the following to the end of your `php.ini`:
#    allow_url_fopen = On

	
}
