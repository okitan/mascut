module Mascut
  class Hamlth
    def initialize(app)
      @app = app
    end
    
    def call(env)
      case path = env['PATH_INFO'].dup # sub!
      when /\.(html|haml)$/
        data = ( File.exist?(path) or File.exist?(path.sub!(/html$/, 'haml')) ) ? hamlize(path) : raise
        [ 200, { 'CONTENT_TYPE' => 'text/html', 'CONTENT_LENGTH' => Rack::Utils.bytesize(data).to_s }, [ data ] ]
      when /\.(css|sass)$/
        data = ( File.exist?(path) or File.exist?(path.sub!(/css$/, 'sass')) ) ? sassize(path) : raise
        [ 200, { 'CONTENT_TYPE' => 'text/css', 'CONTENT_LENGTH' => Rack::Utils.bytesize(data).to_s  }, [ data ] ]
      else
        raise # all raise jumps to app.call
      end
    rescue
      @app.call(env)
    end

    def hamlize(path)
    end

    def sassize(path)
    end
  end
end
