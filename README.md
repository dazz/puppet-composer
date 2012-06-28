# Puppet module to install composer

## Description

install php composer - from http://getcomposer.org/ with puppet-composer module

## Install

    git submodule add git://github.com/dazz/puppet-composer.git modules/composer

## Requirements

This requires additional modues in your project:

    git submodule add git://github.com/puppetlabs/puppetlabs-apt.git modules/apt
    git submodule add git://github.com/puppetlabs/puppetlabs-stdlib.git modules/stdlib
    git submodule add git://github.com/camptocamp/puppet-augeas.git modules/augeas

## Usage

In your manifest.pp:

    ## top block to call apt-get update at least once ##
    include apt::update
    Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
    Exec["apt_update"] -> Package <| |>
    ## end top block ##

    class {"composer":
      target_dir      => '/usr/local/bin',
      composer_file   => 'composer',
      download_method => 'curl', # download methods are curl or wget
      logoutput       => false
    }


The final file is just called 'composer', and placed into the target_dir you entered in your manifest.

@todo test wget method
