# Class: mcollective::params
#
# This module manages the ActiveMQ, stomp, and mcollective parameters
# This should not be directly called
#
class mcollective::params {

  ######################################
  # Server config                      #
  ######################################
  $factsource = 'yaml'
  $pluginyaml = '/etc/mcollective/facts.yaml'

  ######################################
  # Client config                      #
  ######################################
  $client_logfile = '/var/log/mcollective-client.log'
  $configfile_client = '/etc/mcollective/client.cfg'
  $libdir = '/usr/libexec/mcollective'
}
