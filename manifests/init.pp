# == Class: mcollective
#
# This module manages the mcollective package, service, and configs
#
#
# === Parameters
#
# [*stomp_host*]
#   Name of the stomp server
#
# [*stmop_user*]
#   Username to connect to the stomp server with
#
# [*stomp_password*]
#   Password to connect to the stomp server
#
# [*psk*]
#   Pre-shared key
#
# [*client*]
#   Install the client?
#
# [*enabled*]
#   Enable the mcollective service?
#
# [*client_logfile*]
#   Where to write the client logs
#
# [*configfile_client*]
#   Where is the client config file
#
# [*libdir*]
#   The mcollective libdir
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class mcollective(
  $stomp_host,
  $stomp_user,
  $stomp_password,
  $psk,
  $stomp_port         = 61613,
  $client             = 'false',
  $enabled            = 'true',
  $client_logfile     = '/var/log/mcollective-client.log',
  $configfile_client  = '/etc/mcollective/client.cfg',
  $libdir             = '/usr/libexec/mcollective',
){

  include ruby
  include facter

  case $enabled {
    'true', true, True: {
      $real_enabled = true
    }
    default:    {
      $real_enabled = false
    }
  }

  class { 'mcollective::server': enabled => $real_enabled }

  if ( $client == 'true' or $client == true ) {
    include mcollective::client
  }
}
