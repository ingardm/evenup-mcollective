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
  $stomp_host     = $::mcollective::stomp_host,
  $stomp_user     = $::mcollective::stomp_user,
  $stomp_password = $::mcollective::stomp_password,
  $stomp_port     = $::mcollective::stomp_port,
  $psk            = $::mcollective::stomp_psk,
  $plugin_config  = $::mcollective::server_plugin_config,
) {

  file { '/etc/puppetlabs/mcollective/server.cfg':
    ensure  => 'file',
    mode    => '0440',
    owner   => 'puppet',
    group   => 'puppet',
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
