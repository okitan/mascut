require File.join(File.dirname(__FILE__), 'spec_helper')

describe Mascut::VERSION do
  it { should =~ /^\d+\.\d+\.\d+(\w+)?$/ }
end

