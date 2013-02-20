require 'spec_helper'
 
describe 'mcollective', :type => :class do
  let(:hiera_data) { { :mcollective::stomp_user => "bar", 'mcollective::stomp_pass' => 'blah', 'mcollective::psk' => 'thisismykey'} }

  it { should create_class('mcollective') }
  [ 'ruby', 'facter', 'mcollective::server' ].each do |inc_class|
    it { should include_class(inc_class) } 
  end
end

