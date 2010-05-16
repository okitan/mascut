require File.join(File.dirname(__FILE__), 'spec_helper')

describe Mascut do
  it 'should fail' do
    subject::VERSION.should =~ /^\d+\.\d+\.\d+(\w+)?$/
  end
end

