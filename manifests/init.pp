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
# [*client_group*]
#   String.  Group owner of the mcollective client.cfg
#   Default: root
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
  String                                       $stomp_host           = 'localhost',
  String                                       $stomp_user           = 'mcollective',
  String                                       $stomp_password       = 'password',
  Integer                                      $stomp_port           = 61613,
  String                                       $psk                  = 'changeme',
  Boolean                                      $client               = false,
  Array[String]                                $server_packages      = [],
  Array[String]                                $client_packages      = [],
  Optional[Hash[String, Hash[String, Scalar]]] $server_plugin_config = undef,
  Optional[Hash[String, Hash[String, Scalar]]] $client_plugin_config = undef,
  String                                       $client_group         = 'root',
  ){

  class { '::mcollective::install': require => Package['puppet-agent'] } ->
  class { '::mcollective::server': } ->
  class { '::mcollective::service': }
  class { '::mcollective::client': }

}
