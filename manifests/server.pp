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
# Some example mcollective runs
# mco rpc filemgr status file=/etc/puppet/puppet.conf
# mc-pgrep -F lsbmajdistrelease=5 ntp
# mc-puppetd -F ipaddress_eth1=/10.182/ status
# mc-puppetd summary -I hostname.yourdomain.com
# mc-service -C apache httpd status
# mc-puppetd runall 3
# mc-service httpd status
# mco facts lsbdistrelease -v
# mc-nrpe -W lsbdistrelease=5.7 check_load
#
class mcollective::server($enabled = true) inherits mcollective {

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
      content => template('mcollective/server/server.cfg');
  }

  service {
    'mcollective':
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
      notify  => Service['mcollective'];
  }

  # Make sure the provisioner agent is removed
  file { "${mcollective::params::libdir}/mcollective/agent/provision.rb": ensure => 'absent', notify => Service['mcollective'] }

  file {
    '/etc/mcollective/facts.yaml':
      owner     => 'root',
      group     => 'root',
      mode      => '0400',
      content   => template('mcollective/server/facts.yaml'),
      require   => Package['mcollective'];
  }

  # Logrotate for mcollective logs
  logrotate::file {
    'mcollective':
      log         => '/var/log/mcollective.log',
      options     => [ 'missingok', 'notifempty', 'create 0640 root admin', 'sharedscripts', 'weekly' ];
  }
}
