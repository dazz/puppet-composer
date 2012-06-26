# Install php composer - from http://getcomposer.org/

In your manifest:

    class { 'composer':
      targetdir => '/usr/local/bin/'
    }

This requires wget, augeas and php5-cli to be already installed.

    package { ['wget'. 'augeas', 'php5-cli']:
      ensure: present,
    }

The final file is just called 'composer', and placed into the targetdir you entered in your manifest.

@todo clean up the curl/wget dichotomy in the param/init.pp files.
@todo also in params.pp, use of target_dir, etc
