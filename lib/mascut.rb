module Mascut
  VERSION = File.read(File.join(File.dirname(__FILE__), %w[ .. VERSION ])).chomp
  
  autoload :Mascut, 'mascut/mascut'
  autoload :Option, 'mascut/option'
end

