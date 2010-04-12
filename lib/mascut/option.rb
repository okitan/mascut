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
          opts.banner = "Usage: mascut [files] [rack options] [mascut options]"
          
          opts.separator 'Rack options:' # almost same as rack
          opts.on('-s', '--server SERVER', 'serve using SERVER (default: mongrel)') do |s|
            options[:server] = s
          end
          
          opts.on('-o', '--host HOST', 'listen on HOST (default: 0.0.0.0)') do |host|
            options[:Host] = host
          end
          
          opts.on('-p', '--port PORT', 'use PORT (default: 9203)') do |port|
            options[:Port] = port
          end
          
          opts.on('-D', '--daemonize', 'run daemonized in the background') do |d|
            options[:daemonize] = d ? true : false
          end
          
          opts.separator ''
          opts.separator 'Mascut options:'

          opts.on('-m', '--mascut PATH', 'absolute path for comet(default on Mascut::Mascut: /mascut)') do |path|
            options[:mascut] = path.index('/') == 0 ? path : "/#{path}"
          end

          opts.on('-i', '--interval SEC', Float, 'interval to monitor files(default on Mascut::Mascut: 1.0 sec)') do |sec|
            options[:interval] = sec
          end
          
          opts.permute!(args)
          options[:files] = args.size > 0 ? args : nil
        end
      end
    end
  end
end