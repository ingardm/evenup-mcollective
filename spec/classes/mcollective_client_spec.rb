require 'spec_helper'

describe 'mcollective::client', :type => :class do
  let(:params) { { :packages => [ 'mcollective-filemgr-client', 'mcollective-puppet-client'] } }

  context 'default' do
    it { should create_class('mcollective::client') }
    it { should contain_package('mcollective-client') }
    it { should contain_file('/etc/mcollective/client.cfg').with(
      'ensure'  => 'file',
      'mode'    => '0440',
      'owner'   => 'root',
      'group'   => 'root' ) }
    it { should contain_file('/etc/bash_completion.d/mco.sh') }
    it { should contain_package('mcollective-filemgr-client') }
    it { should contain_package('mcollective-puppet-client') }
  end

  context '#client_group' do
    let(:params) { { :client_group => 'mcollective' } }
    it { should contain_file('/etc/mcollective/client.cfg').with(:group => 'mcollective' ) }
    it { should contain_file('/var/log/mcollective-client.log').with(:group => 'mcollective' ) }
  end

end
