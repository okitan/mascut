require 'optparse'

module Mascut
  class Option
    def self.parse(args = ARGV.dup)
      {
        :server => 'mongrel',
        :Host   => '0.0.0.0',
        :Port   => 9203
      }.tap do |options|
        OptionParser.new do |opts|
          opts.separator 'Rack options:' # almost same as rack
          opts.on('-s', '--server SERVER', 'serve using SERVER (default: mongrel)') { |s|
            options[:server] = s
          }
          
          opts.on('-o', '--host HOST', 'listen on HOST (default: 0.0.0.0)') { |host|
            options[:Host] = host
          }
          
          opts.on('-p', '--port PORT', 'use PORT (default: 9203)') { |port|
            options[:Port] = port
          }
          
          opts.on('-D', '--daemonize', 'run daemonized in the background') { |d|
            options[:daemonize] = d ? true : false
          }
          
          opts.separator ''
          opts.separator 'Mascut options:(TODO)'
          
          opts.permute!(args)
          options[:files] = args
        end
      end
    end
  end
end