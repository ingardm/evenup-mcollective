require 'spec_helper'

describe 'mcollective', :type => :class do

  context 'default' do
    it { should contain_file('/etc/puppetlabs/mcollective/client.cfg').with(:ensure => 'absent') }
    it { should_not contain_file('/var/log/puppetlabs/mcollective/mcollective-client.log') }
  end

  context 'with client' do
    let(:params) { { :client => true } }
    it { should contain_file('/etc/puppetlabs/mcollective/client.cfg').with( :group => 'root' ) }
    it { should contain_file('/var/log/puppetlabs/mcollective/mcollective-client.log').with( :group => 'root' ) }

    context 'with client_group' do
      let(:params) { { :client => true, :client_group => 'mcollective' } }
      it { should contain_file('/etc/puppetlabs/mcollective/client.cfg').with( :group => 'mcollective' ) }
      it { should contain_file('/var/log/puppetlabs/mcollective/mcollective-client.log').with( :group => 'mcollective' ) }
    end

  end

end
