# == Class: mcollective
#
# This module manages the mcollective package, service, and configs
#
#
# === Parameters
#
# [*stomp_host*]
#   String.  Name of the stomp server
#
# [*stmop_user*]
#   String.  Username to connect to the stomp server with
#
# [*stomp_password*]
#   String.  Password to connect to the stomp server
#
# [*psk*]
#   String.  Pre-shared key
#
# [*client*]
#   Boolean.  Install the client?
#   Default: false
#
# [*enabled*]
#   Boolean.  Enable the mcollective service?
#   Default: true
#
# [*server_packages*]
#   String/Array of Strings.  Which packages should be installed on the server
#
# [*client_packages*]
#   String/Array of Strings.  Which packages should be intalled on the client
#
# [*client_logfile*]
#   String.  Where to write the client logs
#
# [*configfile_client*]
#   String.  Where is the client config file
#
# [*audit_provider*]
#   String.  Name of the audit provider
#
# [*audit_logfile*]
#   String.  Where should the logfile be stored?
#   Assumes the parameter is plugin.$audit_provider.logfile
#
# [*audit_package*]
#   String.  Name of the package to be installed to provide audit functionality
#
# [*beaver*]
#   Boolean.  Whether or not to add beaver stanzas for logging
#   Default: false
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
  $server_packages    = [],
  $client_packages    = [],
  $client_logfile     = '/var/log/mcollective-client.log',
  $configfile_client  = '/etc/mcollective/client.cfg',
  $audit_provider     = '',
  $audit_logfile      = '',
  $audit_package      = '',
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

  class { 'mcollective::server':
    enabled         => $real_enabled,
    stomp_host      => $stomp_host,
    stomp_port      => $stomp_port,
    stomp_user      => $stomp_user,
    stomp_password  => $stomp_password,
    psk             => $psk,
    packages        => $server_packages,
    audit_package   => $audit_package,
    audit_provider  => $audit_provider,
    audit_logfile   => $audit_logfile,
  }

  if ( $client == 'true' or $client == true ) {
    class { 'mcollective::client': 
      stomp_host      => $stomp_host,
      stomp_port      => $stomp_port,
      stomp_user      => $stomp_user,
      stomp_password  => $stomp_password,
      psk             => $psk,
      client_logfile  => $client_logfile,
      packages        => $client_packages,
    }
  }
}
