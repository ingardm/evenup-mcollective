# == Class: mcollective
#
# This module manages the mcollective service and configs
#
#
class mcollective(
  String                                       $stomp_host           = 'localhost',
  String                                       $stomp_user           = 'mcollective',
  String                                       $stomp_password       = 'password',
  Integer                                      $stomp_port           = 61613,
  Optional[String]                             $psk                  = undef,
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
