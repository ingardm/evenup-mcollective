# == Class: mcollective::server
#
# This class manages the mcollective server service
#
#
class mcollective::server (
  $stomp_host     = $::mcollective::stomp_host,
  $stomp_user     = $::mcollective::stomp_user,
  $stomp_password = $::mcollective::stomp_password,
  $stomp_port     = $::mcollective::stomp_port,
  $psk            = $::mcollective::psk,
  $plugin_config  = $::mcollective::server_plugin_config,
) {

  file { '/etc/puppetlabs/mcollective/server.cfg':
    ensure  => 'file',
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
    content => template('mcollective/server/server.cfg.erb'),
    notify  => Service['mcollective'],
  }

  file { '/etc/puppetlabs/mcollective/facts.yaml':
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => template('mcollective/server/facts.yaml.erb'),
  }

}
