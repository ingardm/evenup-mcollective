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
class mcollective inherits mcollective::params {

  include ruby
  include facter

  $stomp_host = hiera('mcollective::stomp_host')
  $stomp_user = hiera('mcollective::stomp_user')
  $stomp_password = hiera('mcollective::stomp_pass')
  $stomp_port = hiera('mcollective::stomp_port', 61613)
  $psk = hiera('mcollective::psk')
  $client_real = hiera('mcollective::client', 'no')
  $enabled = hiera('mcollective::enabled', True)

  case $enabled {
    true, True: {
      $real_enabled = true
    }
    default:    {
      $real_enabled = false
    }
  }

  class { 'mcollective::server': enabled => $real_enabled }

  if ( $client_real == 'yes' ) {
    include mcollective::client
  }
}
