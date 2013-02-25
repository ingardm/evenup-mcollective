# Class: mcollective::server
#
# This module manages the mcollective server
#
# Requires:
# java, ruby
#
# Sample Usage:
#   include mcollective::server
#
class mcollective::server($enabled = true) {

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
  package {
    'mcollective':
      ensure  => 'latest',
      notify  => Service['mcollective'];

    'rubygem-stomp':
      ensure  => 'present',
      notify  => Service['mcollective'];
  }

  file {
    '/etc/mcollective/server.cfg':
      ensure  => $present,
      mode    => '0440',
      owner   => 'root',
      group   => 'root',
      require => Package['mcollective'],
      content => template('mcollective/server/server.cfg.erb');
  }

  service {
    'mcollective':
      ensure     => $running,
      enable     => $enabled,
      require    => Package['mcollective'],
      subscribe  => File['/etc/mcollective/server.cfg.erb'];
  }

  package {
    [ 'mcollective-filemgr-agent', 'mcollective-package-agent',
      'mcollective-puppet-agent', 'mcollective-service-agent',
      'mcollective-process-agent', 'rubygem-sys-proctable' ]:
      ensure  => latest,
      notify  => Service['mcollective'];
  }

  # Make sure the provisioner agent is removed
  file { "${mcollective::libdir}/mcollective/agent/provision.rb": ensure => 'absent', notify => Service['mcollective'] }

  file {
    '/etc/mcollective/facts.yaml':
      owner     => 'root',
      group     => 'root',
      mode      => '0400',
      content   => template('mcollective/server/facts.yaml.erb'),
      require   => Package['mcollective'];
  }

  # Logrotate for mcollective logs
  logrotate::file {
    'mcollective':
      log         => '/var/log/mcollective.log',
      options     => [ 'missingok', 'notifempty', 'create 0640 root admin', 'sharedscripts', 'weekly' ];
  }
}
