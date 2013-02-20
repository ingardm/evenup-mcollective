require 'spec_helper'
 
describe 'mcollective::client', :type => :class do

  it { should create_class('mcollective::client') }
  it { should contain_package('mcollective-client') }
  it { should create_file('/etc/mcollective/client.cfg').with(
    'ensure'  => 'file',
    'mode'    => '0440',
    'owner'   => 'root',
    'group'   => 'admin' ) }
  it { should contain_file('/etc/bash_completion.d/mco.sh') }
  it { should create_logrotate__file('mcollective-client') }

end
