class composer($targetdir) {

    include composer::params

    file { $targetdir:
      ensure => directory
    }

    # trage werte in die php.ini ein
    # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
    augeas { 'whitelist_phar':
      context => '/files/etc/php5/conf.d/suhosin.ini/suhosin',
      changes => 'set suhosin.executor.include.whitelist phar',
      require => [
        Package['php5-cli'],
      ],
    }

    augeas{ 'allow_url_fopen':
      context => '/files/etc/php5/cli/php.ini/PHP',
      changes => 'set allow_url_fopen On',
      require => [
        Package['php5-cli'],
      ],
    }

    # download composer, put into target dir and make executable.
    exec { 'download_composer':
      command   => 'wget http://getcomposer.org/composer.phar -O composer',
      require   => [Package['wget'], File[$targetdir]],
      logoutput => true,
      creates   => "$targetdir/composer.phar",
      cwd       => $targetdir,
      user      => root,
    }

    file { "$targetdir/composer":
      mode   => '0755',
    }
}
