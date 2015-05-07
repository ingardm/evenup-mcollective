# == Class: mcollective::service
#
# This class manages the mcollective service
#
#
class mcollective::service {

  service { 'mcollective':
    ensure => 'running',
    enable => true,
  }

}