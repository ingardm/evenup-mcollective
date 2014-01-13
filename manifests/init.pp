# == Class: mcollective
#
# This module manages the mcollective package, service, and configs
#
#
# === Parameters
#
# [*stomp_host*]
#   String.  Name of the stomp server
#   Default: localhost
#
# [*stmop_user*]
#   String.  Username to connect to the stomp server with
#   Default: mcollective
#
# [*stomp_password*]
#   String.  Password to connect to the stomp server
#   Default: password
#
# [*psk*]
#   String.  Pre-shared key
#   Default: changeme
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
# [*classes_file*]
#   String.  Location of puppet classes.txt cache file
#   Default: /var/lib/puppet/classes.txt
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
# [*resource_allow_managed_resources*]
#   Boolean.  Should the mcollective puppet agent be allowed to manage resources managed by puppet?
#   Default: false
#
# [*resource_type_whitelist*]
#   String.  List of types allowed to be managed by the mcollective puppet agent.
#   Cannot be set with resource_type_blacklist.
#
# [*resource_type_blacklist*]
#   String.  List of types denied to be managed by the mcollective puppet agent.
#   Cannot be set with resource_type_whitelist.
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
  $stomp_host                       = 'localhost',
  $stomp_user                       = 'mcollective',
  $stomp_password                   = 'password',
  $stomp_port                       = 61613,
  $psk                              = 'changeme',
  $client                           = false,
  $enabled                          = true,
  $server_packages                  = [],
  $client_packages                  = [],
  $classes_file                     = '/var/lib/puppet/classes.txt',
  $client_logfile                   = '/var/log/mcollective-client.log',
  $configfile_client                = '/etc/mcollective/client.cfg',
  $audit_provider                   = '',
  $audit_logfile                    = '',
  $audit_package                    = '',
  $resource_allow_managed_resources = false,
  $resource_type_whitelist          = undef,
  $resource_type_blacklist          = undef,
  $beaver                           = false,
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
    enabled                   => $real_enabled,
    stomp_host                => $stomp_host,
    stomp_port                => $stomp_port,
    stomp_user                => $stomp_user,
    stomp_password            => $stomp_password,
    psk                       => $psk,
    classes_file              => $classes_file,
    packages                  => $server_packages,
    audit_package             => $audit_package,
    audit_provider            => $audit_provider,
    audit_logfile             => $audit_logfile,
    resource_type_whitelist   => $resource_type_whitelist,
    resource_type_blacklist   => $resource_type_blacklist,
    beaver                    => $beaver,
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
