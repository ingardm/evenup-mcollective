# == Class: mcollective::server
#
# This class manages the mcollective server service
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
class mcollective::server (
  $stomp_host,
  $stomp_user,
  $stomp_password,
  $psk,
  $enabled        = true,
  $stomp_port     = 61613,
  $packages       = [],
  $audit_package  = '',
  $audit_provider = '',
  $audit_logfile  = '',
) {

  case $enabled {
    true:     {
      $running  = 'running'
      $present  = 'file'
    }
    default:  {
      $running  = 'stopped'
      $present  = 'absent'
    }
  }

  # Set up mcollective
  Package { notify => Service['mcollective'], ensure => 'latest' }

  package { ['mcollective', 'rubygem-stomp']: }

  package { $packages: }

  if $audit_package != '' {
    package { $audit_package: }
  }

  file { '/etc/mcollective/server.cfg':
    ensure  => $present,
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
    require => Package['mcollective'],
    content => template('mcollective/server/server.cfg.erb');
  }

  service { 'mcollective':
    ensure     => $running,
    enable     => $enabled,
    require    => Package['mcollective'],
    subscribe  => File['/etc/mcollective/server.cfg'];
  }


  # Make sure the provisioner agent is removed
  file { '/usr/libexec/mcollective/mcollective/agent/provision.rb': ensure => 'absent', notify => Service['mcollective'] }

  file { '/etc/mcollective/facts.yaml':
    owner     => 'root',
    group     => 'root',
    mode      => '0400',
    content   => template('mcollective/server/facts.yaml.erb'),
    require   => Package['mcollective'];
  }

  if $audit_logfile != '' {
    if $mcollective::beaver {
      beaver::stanza { $audit_logfile:
        type    => 'mcollective-audit',
        tags    => [$::disposition],
        format  => 'rawjson',
      }
    }

    logrotate::file { 'mcollective-audit':
      log         => $audit_logfile,
      options     => [ 'missingok', 'notifempty', 'create 0644 root root', 'sharedscripts', 'weekly', 'compress' ];
    }
  }

  # Logrotate for mcollective logs
  logrotate::file { 'mcollective':
    log         => '/var/log/mcollective.log',
    options     => [ 'missingok', 'notifempty', 'create 0644 root root', 'sharedscripts', 'weekly', 'compress' ];
  }
}
