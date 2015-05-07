class mcollective::install (
  $client          = $::mcollective::client,
  $client_packages = $::mcollective::client_packages,
  $server_packages = $::mcollective::server_packages,
){

  # Plugins directory is not created by the puppet-agent 1.0.1 installer, create
  file { [ '/opt/puppetlabs/mcollective', '/opt/puppetlabs/mcollective/plugins' ]:
    ensure => 'directory',
    owner  => 'puppet',
    group  => 'puppet',
  }

  file { '/var/log/puppetlabs/mcollective':
    ensure => 'directory',
    owner  => 'puppet',
    group  => 'puppet',
  }

  package { $server_packages:
    notify => Class['::mcollective::service'],
  }

  if $client {
    package { $client_packages: }
  }

}