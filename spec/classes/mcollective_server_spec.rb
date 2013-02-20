require 'spec_helper'
 
describe 'mcollective::server', :type => :class do

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


end
