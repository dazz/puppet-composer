class composer(
  $target_dir      = '/usr/local/bin',
  $composer_file   = 'composer',
  $download_method = 'curl',
  $logoutput       = false,
  $tmp_path        = '/home/vagrant') {

  include augeas

  $php_package     = 'php5-cli'

  if defined(Package[$php_package]) == false {
    package { $php_package: ensure => present, }
  }

  # download composer
  if $download_method == 'curl' {

    if defined(Package['curl']) == false {
      package { 'curl': ensure => present, }
    }

    exec { 'download_composer':
      path   => "/usr/bin:/usr/sbin:/bin", 
      command     => 'curl -s http://getcomposer.org/installer | php',
      cwd         => $tmp_path,
      require     => [
        Package['curl', $php_package],
        Augeas['whitelist_phar', 'allow_url_fopen'], ],
      creates     => "$tmp_path/composer.phar",
      logoutput   => $logoutput,
    }
  }
  elsif $download_method == 'wget' {

    if defined(Package['wget']) == false {
      package {'wget': ensure => present, }
    }

    exec { 'download_composer':
       path   => "/usr/bin:/usr/sbin:/bin", 
       command     => 'wget http://getcomposer.org/composer.phar -O composer.phar',
      cwd         => $tmp_path,
      require     => [
        Package['wget'],
        Augeas['whitelist_phar', 'allow_url_fopen'], ],
      creates     => "$tmp_path/composer.phar",
      logoutput   => $logoutput,
    }
  }
  else {
    fail("The param download_method $download_method is not valid. Please set download_method to curl or wget.")
  }

  # check if directory exists
  file { $target_dir:
    ensure      => directory,
  }

  # move file to target_dir
  file { "$target_dir/$composer_file":
    ensure      => present,
    source      => "$tmp_path/composer.phar",
    require     => [ Exec['download_composer'], File[$target_dir], ],
    group       => 'staff',
    mode        => '0755',
  }

  # run composer self-update
  exec { 'update_composer':
    command     => "$target_dir/$composer_file self-update",
    require     => File["$target_dir/$composer_file"],
  }

  # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
  augeas { 'whitelist_phar':
    context     => '/files/etc/php5/conf.d/suhosin.ini/suhosin',
    changes     => 'set suhosin.executor.include.whitelist phar',
    require     => Package[$php_package],
  }

  # set /etc/php5/cli/php.ini/PHP/allow_url_fopen = On
  augeas{ 'allow_url_fopen':
    context     => '/files/etc/php5/cli/php.ini/PHP',
    changes     => 'set allow_url_fopen On',
    require     => Package[$php_package],
  }
}
