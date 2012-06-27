class composer( $target_dir = "/usr/local/bin", $composer_file = "composer" ) {

  include augeas

  package {["curl", "php5-cli"]:
    ensure => present,
  }

  $download_url = "http://getcomposer.org/installer"
  $tmp_path     = "/home/vagrant"

  # download composer
  exec { "download_composer":
    command     => "curl -s $download_url | php",
    logoutput   => true,
    cwd         => $tmp_path,
    require     => [
      Package["curl", "php5-cli"],
      Augeas["whitelist_phar", "allow_url_fopen"],],
    creates     => "$tmp_path/composer.phar",
  }

  # check if directory exists
  file { "$target_dir":
    ensure => directory,
  }

  # move file to target_dir
  file { "$target_dir/$composer_file":
    ensure      => present,
    source      => "$tmp_path/composer.phar",
    require     => [
      Exec["download_composer"],
      File["$target_dir"],],
    group       => "staff",
    mode        => "0755",
  }

  # run composer self-update
  exec { "update_composer":
    command     => "$target_dir/$composer_file self-update",
    require     => File["$target_dir/$composer_file"],
  }

  # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
  augeas { "whitelist_phar":
    context     => "/files/etc/php5/conf.d/suhosin.ini/suhosin",
    changes     => "set suhosin.executor.include.whitelist phar",
    require     => Package["php5-cli"],
  }

  augeas{ "allow_url_fopen":
    context     => "/files/etc/php5/cli/php.ini/PHP",
    changes     => "set allow_url_fopen On",
    require     => Package["php5-cli"],
  }
}