module Mascut
  class Hamlth
    def initialize(app)
      @app = app
    end
    
    def call(env)
      case path = env['PATH_INFO'].dup # sub!
      when /\.(html|haml)$/
        ( File.exist?(path) or File.exist?(path.sub!(/html$/, 'haml')) ) ? hamlize(path) : raise
      when /\.(css|sass)$/
        ( File.exist?(path) or File.exist?(path.sub!(/css$/, 'sass')) ) ? sassize(path) : raise
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
