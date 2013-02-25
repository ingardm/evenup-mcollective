# Class: mcollective::client
#
# This module manages the mcollective client
#
# Sample Usage:
#   include mcollective::client
#
class mcollective::client {

  package { 'mcollective-client':
    ensure => 'latest',
  }

  file { '/etc/mcollective/client.cfg':
    ensure  => file,
    mode    => '0440',
    owner   => root,
    group   => admin,
    require => Package['mcollective-client'],
    content => template('mcollective/client/client.cfg.erb'),
  }

  file { $mcollective::client_logfile:
    owner => root,
    group => admin,
    mode  => '0660',
  }

  file { '/etc/bash_completion.d/mco.sh':
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/mcollective/mco.sh',
  }

  # Logrotate for mcollective client logs
  logrotate::file { 'mcollective-client':
    log     => $mcollective::client_logfile,
    options => ['missingok', 'notifempty', 'create 0660 root admin', 'sharedscripts', 'weekly'];
  }

  package {
    [ 'mcollective-filemgr-client', 'mcollective-package-client',
      'mcollective-service-client', 'mcollective-puppet-client' ]:
      ensure  => latest,
      notify  => Service['mcollective'];
  }
}
