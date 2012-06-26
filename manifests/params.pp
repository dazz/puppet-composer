class composer::params {

  # 'wget' or 'curl'
  $download_method = $download_method ? {
    ''      => 'wget',
    default => $download_method
  }

  $download_url = $download_url ? {
    ''      => 'http://getcomposer.org/installer',
    default => $download_url,
  }

  $target_dir = $target_dir ? {
    ''      => '/usr/local/bin',
    default => $target_dir,
  }

  $exec_download = $exec_download ? {
    ''      => $download_method ? {
      'wget'  => 'wget http://getcomposer.org/composer.phar',
      'curl'  => 'curl -s http://getcomposer.org/installer | php',
      default => 'curl -s http://getcomposer.org/installer | php'
    },
    default => $exec_download
  }

}
