require 'spec_helper'

describe 'mcollective', :type => :class do
  let(:params) { { :stomp_host => 'stomp', :stomp_user => 'mcollective', :stomp_password => 'password', :psk => 'string' } }

  it { should create_class('mcollective') }
  it { should contain_class('mcollective::server') }
end

