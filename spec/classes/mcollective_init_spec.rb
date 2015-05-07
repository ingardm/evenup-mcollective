require 'spec_helper'

describe 'mcollective', :type => :class do

  it { should create_class('mcollective') }
  it { should contain_class('mcollective::install') }
  it { should contain_class('mcollective::server') }
  it { should contain_class('mcollective::service') }
  it { should contain_class('mcollective::client') }
end

