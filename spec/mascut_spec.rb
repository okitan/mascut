require 'spec_helper'

describe Mascut::VERSION do
  it { should =~ /^\d+\.\d+\.\d+(\w+)?$/ }
end

