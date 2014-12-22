require 'spec_helper'

describe 'mcollective::server', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }
  let(:params) { { :packages => [ 'mcollective-filemgr-agent', 'mcollective-puppet-agent'] } }

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
  it { should contain_package('mcollective-filemgr-agent') }
  it { should contain_package('mcollective-puppet-agent') }

  context 'when audit logging enabled' do
    let(:params) { { :audit_provider => 'Logstash' } }

    it { should contain_file('/etc/mcollective/server.cfg').with_content(/rpcauditprovider\s\=\sLogstash/) }
    it { should_not contain_file('/etc/mcollective/server.cfg').with_content(/plugin.logstash.logfile/) }
  end

  context 'with audit package and logfile' do
    let(:params) { {
      :audit_provider => 'Logstash',
      :audit_package  => 'mcollective-logstash-audit',
      :audit_logfile  => '/var/log/foo.json'
    } }

    it { should contain_package('mcollective-logstash-audit') }
    it { should contain_file('/etc/mcollective/server.cfg').with_content(/rpcauditprovider\s\=\sLogstash/) }
    it { should contain_file('/etc/mcollective/server.cfg').with_content(/plugin.logstash.logfile\s\=\s\/var\/log\/foo\.json/) }
    it { should_not contain_beaver__stanza('/var/log/json.foo') }

    context 'with beaver' do
      let(:facts) { { :concat_basedir => '/var/lib/puppet/concat', :disposition => 'prod' } }
      let(:params) { {
        :audit_provider => 'Logstash',
        :audit_package  => 'mcollective-logstash-audit',
        :audit_logfile  => '/var/log/foo.json',
        :beaver         => true,
      } }

      it { should contain_beaver__stanza('/var/log/foo.json') }
    end
  end

  context 'plugin resource management' do
    context 'default' do
      it { should contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_allow_managed_resources = false/) }
      it { should_not contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_type_whitelist/) }
      it { should_not contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_type_blacklist/) }
    end

    context 'set allow managed resources' do
      let(:params) { { :resource_allow_managed_resources => true } }
      it { should contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_allow_managed_resources = true/) }
    end

    context 'whitelist' do
      let(:params) { { :resource_type_whitelist => 'service' } }
      it { should contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_type_whitelist = service/) }
      it { should_not contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_type_blacklist/) }
    end

    context 'blacklist' do
      let(:params) { { :resource_type_blacklist => 'service' } }
      it { should contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_type_blacklist = service/) }
      it { should_not contain_file('/etc/mcollective/server.cfg').with_content(/plugin\.puppet\.resource_type_whitelist/) }
    end

    context 'not allow setting blacklist and whitelist' do
      let(:params) { { :resource_type_whitelist => 'exec', :resource_type_blacklist => 'service' } }
      it { expect { should raise_error(Puppet::Error) } }
    end

  end

end
