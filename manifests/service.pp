class mcollective::service {

  service { 'mcollective':
    ensure => 'running',
    enable => true,
  }

}