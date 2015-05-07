require 'spec_helper'

describe 'mcollective', :type => :class do
  context 'default' do
    it { should contain_file('/opt/puppetlabs/mcollective') }
    it { should contain_file('/opt/puppetlabs/mcollective/plugins') }
    it { should contain_file('/var/log/puppetlabs/mcollective') }
  end

  context 'server_packages' do
    let(:params) { { :server_packages => [ 'mcollective-filemgr-agent'], :client_packages => [ 'mcollective-filemgr-client' ] } }
    it { should contain_package('mcollective-filemgr-agent') }
    it { should_not contain_package('mcollective-filemgr-client') }
  end

  context 'client_packages' do
    let(:params) { { :client => true, :client_packages => [ 'mcollective-filemgr-client' ] } }
    it { should contain_package('mcollective-filemgr-client') }
  end

end
