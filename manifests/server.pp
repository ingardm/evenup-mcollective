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
  $audit_provider = '',
  $audit_package  = '',
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

  Package { notify  => Service['mcollective'] }
  # Set up mcollective
  package { 'mcollective':
    ensure  => 'latest',
  }

  package { 'rubygem-stomp':
    ensure  => 'present',
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

  package {
    [ 'mcollective-filemgr-agent', 'mcollective-package-agent',
      'mcollective-puppet-agent', 'mcollective-service-agent',
      'mcollective-process-agent', 'rubygem-sys-proctable' ]:
      ensure  => latest,
  }

  if $audit_package != '' {
    package { $audit_package:
      ensure  => latest,
    }
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
    beaver::stanza { $audit_logfile:
      type    => 'mcollective-audit',
      tags    => [$::disposition],
      format  => 'rawjson',
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
