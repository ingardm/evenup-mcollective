require 'spec_helper'
 
describe 'mcollective', :type => :class do
  let(:params) { { :stomp_host => 'stomp', :stomp_user => 'mcollective', :stomp_password => 'password', :psk => 'string' } }

  it { should create_class('mcollective') }
  [ 'ruby', 'facter', 'mcollective::server' ].each do |inc_class|
    it { should include_class(inc_class) } 
  end
end

