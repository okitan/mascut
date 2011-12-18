$: << File.join(File.dirname(__FILE__), %w[ .. lib ])
require 'mascut'

require 'rubygems'
require 'rack'
require 'rr'

RSpec.configure do |config|
  config.mock_with :rr

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
end
