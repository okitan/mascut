require 'haml'
require 'sass'

module Mascut
  class Hamlth
    def initialize(app)
      @app = app
    end
    
    def call(env)
      case path = env['PATH_INFO'][1..-1] # remove / and path is now relative
      when /\.(html|haml)$/
        data = ( File.exist?(path) or File.exist?(path.sub!(/html$/, 'haml')) ) ? hamlize(path) : raise
        [ 200, { 'Content-Type' => 'text/html', 'Content-Length' => Rack::Utils.bytesize(data).to_s }, [ data ] ]
      when /\.(css|sass)$/
        data = ( File.exist?(path) or File.exist?(path.sub!(/css$/, 'sass')) ) ? sassize(path) : raise
        [ 200, { 'Content- type' => 'text/css', 'Content-Length' => Rack::Utils.bytesize(data).to_s  }, [ data ] ]
      else
        raise # all raise jumps to app.call
      end
    rescue => e
      @app.call(env)
    end

    def hamlize(path)
      Haml::Engine.new(File.read(path)).to_html
    end

    def sassize(path)
      Sass::Engine.new(File.read(path)).to_css
    end
  end
end
