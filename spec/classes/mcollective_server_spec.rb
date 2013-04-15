require 'spec_helper'

describe 'mcollective::server', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }
  let(:params) { {
    :stomp_host => 'stomp',
    :stomp_user => 'mcollective',
    :stomp_password => 'password',
    :psk => 'string',
    :packages => [ 'mcollective-filemgr-agent', 'mcollective-puppet-agent']
  } }

  it { should create_class('mcollective::server') }
  it { should contain_package('mcollective') }
  it { should contain_package('rubygem-stomp') }
  it { should contain_service('mcollective').with_ensure('running') }
  it { should contain_file('/etc/mcollective/server.cfg').with(
    'ensure'  => 'file',
    'mode'    => '0440',
    'owner'   => 'root',
    'group'   => 'root' )}
  it { should contain_file('/etc/mcollective/facts.yaml').with_mode('0400') }
  it { should contain_logrotate__file('mcollective') }
  it { should contain_package('mcollective-filemgr-agent') }
  it { should contain_package('mcollective-puppet-agent') }

  context 'when audit logging enabled' do
    let(:params) { {
      :stomp_host => 'stomp',
      :stomp_user => 'mcollective',
      :stomp_password => 'password',
      :psk => 'string',
      :audit_provider => 'Logstash'
    } }

    it { should contain_file('/etc/mcollective/server.cfg').with_content(/rpcauditprovider\s\=\sLogstash/) }
    it { should_not contain_file('/etc/mcollective/server.cfg').with_content(/plugin.logstash.logfile/) }
  end

  context 'with audit package and logfile' do
    let(:params) { {
      :stomp_host => 'stomp',
      :stomp_user => 'mcollective',
      :stomp_password => 'password',
      :psk => 'string',
      :audit_provider => 'Logstash',
      :audit_package  => 'mcollective-logstash-audit',
      :audit_logfile  => '/var/log/foo.json'
    } }

    it { should contain_package('mcollective-logstash-audit') }
    it { should contain_file('/etc/mcollective/server.cfg').with_content(/rpcauditprovider\s\=\sLogstash/) }
    it { should contain_file('/etc/mcollective/server.cfg').with_content(/plugin.logstash.logfile\s\=\s\/var\/log\/foo\.json/) }
  end

end
