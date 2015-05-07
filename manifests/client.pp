# == Class: mcollective::client
#
# This class manages the mcollective client config
#
#
class mcollective::client (
  $client         = $::mcollective::client,
  $stomp_host     = $::mcollective::stomp_host,
  $stomp_user     = $::mcollective::stomp_user,
  $stomp_password = $::mcollective::stomp_password,
  $stomp_port     = $::mcollective::stomp_port,
  $psk            = $::mcollective::psk,
  $client_group   = $::mcollective::client_group,
  $plugin_config  = $::mcollective::client_plugin_config,
) {

  if $client {
    $ensure = 'file'
  } else {
    $ensure = 'absent'
  }

  file { '/etc/puppetlabs/mcollective/client.cfg':
    ensure  => $ensure,
    mode    => '0440',
    owner   => root,
    group   => $client_group,
    content => template('mcollective/client/client.cfg.erb'),
  }

  if $client {
    file { '/var/log/puppetlabs/mcollective/mcollective-client.log':
      ensure => 'file',
      owner  => root,
      group  => $client_group,
      mode   => '0660',
    }
  }

}
