What is it?
===========

Puppet module to configure mcollective using ActiveMQ.

Released under the Apache 2.0 licence

Usage:
------

To install:
<pre>
  class { 'mcollective':
    stomp_host      => 'stomp',
    stomp_user      => 'mcollective',
    stomp_password  => 'mcollective',
    psk             => 'mySecretPSK'
  }
</pre>

You can enable audit logging by specifying the audit_provider parameter.  If
you need to include a package for it as well you can specify audit_package.
<pre>
  class { 'mcollective':
    stomp_host      => 'stomp',
    stomp_user      => 'mcollective',
    stomp_password  => 'mcollective',
    psk             => 'mySecretPSK',
    audit_provider  => 'Logstash',
    audit_package   => 'mcollective-logstash-audit',
    audit_logfile   => '/var/log/mcollective/audit.json',
  }
  
</pre>

TODO:
____
- [ ] Move installed plugins outside of module
- [x] Parameters for auditing
- [ ] Allow enable/disable log shipping (beaver right now)

Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
