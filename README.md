What is it?
===========

Puppet module to configure mcollective using ActiveMQ.

Released under the Apache 2.0 licence

Usage:
------

To install:
<pre>
  include mcollective
</pre>

Hiera configuration:
<pre>
  mcollective::stomp_host - Stomp host
  mcollective::stomp_user - Stomp username
  mcollective::stomp_pass - Stomp password
  mcollective::stomp_port - Stomp port (Default: 61613)
  mcollective::psk - Pre-shared key
  mcollective::client - Install client packages? (Default: no)
  mcollective::enabled - Enabled? (Default: True)
</pre>


Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
