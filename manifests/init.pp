# Class: mcollective
#
# This module manages mcollective
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   class {'mcollective': }
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
