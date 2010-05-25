module Mascut
  VERSION = File.read(File.join(File.dirname(__FILE__), %w[ .. VERSION ])).chomp

  autoload :Hamlth, 'mascut/hamlth'
  autoload :Mascut, 'mascut/mascut'
  autoload :Option, 'mascut/option'
end

