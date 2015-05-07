require 'spec_helper'

describe 'mcollective', :type => :class do

  it { should contain_service('mcollective').with(:ensure => 'running', :enable => true) }

end
