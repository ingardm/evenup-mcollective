#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mcollective](#setup)
    * [What mcollective affects](#what-mcollective-affects)
    * [Beginning with mcollective](#beginning-with-mcollective)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Agent Configuration](#agent-configuration)
    * [Server Configuration](#server-configuration)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [TODO](#todo)
8. [Development - Guide for contributing to the module](#development)
9. [Changelog/Contributors](#changelog-contributors)

## Overview

A puppet module to manage the configuration of mcollective when installed as part of the puppet 4 AIO installation.

## Module Description

This module configures the server component and optionally the client configuration.

Requirements for this module is puppet >= 4.0 with the AIO installer.  The [evenup/puppet](forge.puppetlabs.com/evenup/puppet)
is one module that can meet this need.  Mcollective also requiers an working ActiveMQ
(or RabbitMQ - not supported by this module at this time) setup

## Setup

### What puppet affects

* /etc/puppetlabs/mcollective/server.cfg
* mcollective service
* /etc/puppetlabs/mcollective/client.cfg (optional)
* client and agent packages (optional)

### Beginning with mcollective

This module can be installed with

```
  puppet module install evenup-mcollective
```

## Usage

Installing the server component:

```puppet
  class { 'mcollective':
    stomp_host     => 'activemq.company.com',
    stomp_user     => 'mcollective',
    stomp_password => 'secretpass',
  }
```

Adding the client to a node and accessible to users in the `mco-users` group:

```puppet
  class { 'mcollective':
    stomp_host     => 'activemq.company.com',
    stomp_user     => 'mcollective',
    stomp_password => 'secretpass',
    client         => true,
    client_group   => 'mco-users',
  }
```

###Parameters

#### Agent Configuration

#####`stomp_host`
String.  Hostname (or IP) of the ActiveMQ server

Default: localhost

#####`stomp_user`
String.  Username to connect to stomp server as

Default: mcollective

#####`stomp_password`
String.  Password for stomp_user

Default: password

#####`stomp_port`
Integer.  ActiveMQ port

Default: 61613

#####`psk`
String.  Pre-shared key for encryptoin

Default: undef

#####`client`
Boolean.  Whether or not the client should be configured

Default: false

#####`server_packages`
Array[String].  List of packages to be installed with the server role

Default: []

#####`client_packages`
Array[String].  List of packages to be installed with the client role

Default: []

#####`client_group`
String.  Group that owns the client configuration.  This allows keeping the configuration
secure from users who don't need it, but allows for non-root mco access


## Reference

### Classes

#### Public Classes

* `mcollective`: Entry point for configuring the module

#### Private Classes

* `mcollective::install`: Installs packages defined in server_packages and client_packages, create paths
* `mcollective::server`: Configures the server role
* `mcollective::client`: Configures the client role
* `mcollective::service`: Manages the mcollective service

## Limitations

### General

This module currently does not have acceptnace tests and is tested on CentOS 6 and 7.  It *should* work on
Ubuntu machines without issue.

## TODO

[ ] Add acceptance tests
[ ] Allow RabbitMQ config
[ ] Allow SSL config

## Development

Improvements and bug fixes are greatly appreciated.  See the [contributing guide](https://github.com/evenup/evenup-mcollective/CONTRIBUTING.md) for
information on adding and validating tests for PRs.

## Changelog / Contributors

[Changelog](https://github.com/evenup/evenup-mcollective/blob/master/CHANGELOG)

[Contributors](https://github.com/evenup/evenup-mcollective/graphs/contributors)
