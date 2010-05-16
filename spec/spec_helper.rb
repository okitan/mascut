$: << File.join(File.dirname(__FILE__), %w[ .. lib ])
require 'mascut'

require 'rubygems'
require 'rack'
require 'rr'

Spec::Runner.configure do |config|
  config.mock_with :rr
end
