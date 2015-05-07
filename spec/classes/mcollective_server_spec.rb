require 'spec_helper'

describe 'mcollective', :type => :class do
  let(:params) { { :server_packages => [ 'mcollective-filemgr-agent', 'mcollective-puppet-agent'] } }

  it { should contain_file('/etc/puppetlabs/mcollective/server.cfg').with(:mode => '0440') }
  it { should contain_file('/etc/puppetlabs/mcollective/facts.yaml').with(:mode => '0400') }

  context 'plugin config' do
    let(:params) { { :server_plugin_config => { 'puppet' => { 'resource_allow_managed_resources' => true, 'resource_type_whitelist' => 'host,alias' } } } }
    it { should contain_file('/etc/puppetlabs/mcollective/server.cfg').with(:content => /plugin\.puppet\.resource_allow_managed_resources = true/)}
    it { should contain_file('/etc/puppetlabs/mcollective/server.cfg').with(:content => /plugin\.puppet\.resource_type_whitelist = host,alias/)}
  end

end
