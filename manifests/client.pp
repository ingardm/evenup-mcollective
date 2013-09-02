# == Class: mcollective::client
#
# This class manages the mcollective client config
#
#
# === Parameters
#
# See the init.pp for parameter information.  This class should not be direclty called.
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#


# Class: mcollective::client
#
# This module manages the mcollective client
#
# Sample Usage:
#   include mcollective::client
#
class mcollective::client (
  $stomp_host     = 'localhost',
  $stomp_user     = 'mcollective',
  $stomp_password = 'password',
  $psk            = 'changeme',
  $stomp_port     = 61613,
  $client_logfile = '/var/log/mcollective-client.log',
  $packages       = [],
) {

  package { 'mcollective-client':
    ensure => 'latest',
  }

  file { '/etc/mcollective/client.cfg':
    ensure  => file,
    mode    => '0440',
    owner   => root,
    group   => root,
    require => Package['mcollective-client'],
    content => template('mcollective/client/client.cfg.erb'),
  }

  file { $mcollective::client_logfile:
    owner => root,
    group => root,
    mode  => '0660',
  }

  file { '/etc/bash_completion.d/mco.sh':
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/mcollective/mco.sh',
  }

  # Logrotate for mcollective client logs
  logrotate::file { 'mcollective-client':
    log     => $client_logfile,
    options => ['missingok', 'notifempty', 'create 0660 root admin', 'sharedscripts', 'weekly'];
  }

  package { $packages:
    ensure  => latest,
  }
}
