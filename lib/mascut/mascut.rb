module Mascut
  class Mascut
    def initialize(app, path = nil, files = nil, opts = nil)
      @app   = app
      @path  = path  || '/mascut'
      @files = files || Dir['**/*']
      @opts  = opts  || {}
    end

    def call(env)
      if env['PATH_INFO'] == @path
        mascut
      else
        status, headers, body = @app.call(env)
        if status == 200 and headers['Content-Type'] =~ /^text\/html/
          body = [ File.read(body.path) ] if body.is_a?(Rack::File)
          if body.kind_of?(Rack::Response)
            # this code is not well considered
            body.body = mascutize(body.body)
            headers['Content-Length'] = body.length.to_s
          else
            body.map! {|html| mascutize(html) }
            headers['Content-Length'] = body.to_a.inject(0) {|len, part| len + Rack::Utils.bytesize(part) }.to_s
          end
        end

        [ status, headers, body ]
      end
    end

    def mascut
      now = Time.now
      
      catch :reload do
        loop do 
          @files.each {|file| throw(:reload, 'reload') if File.exist?(file) and now < File.mtime(file) }
          sleep(@opts[:interval] || 1.0)
        end
      end
      
      [ 200, { 'Cache-Control' => 'no-cache', 'Pragma' => 'no-cache', 'Content-Type' => 'text/plain' },  ['reload'] ]
    end

    def mascutize(html)
      # I don't use html parser like nokogiri, because it corrects html to be debugged
      html.sub('</head>', @opts[:jquery] ? <<-LOCAL : <<-REMOTE)
  <script src='#{@opts[:jquery]}'></script>
  <script>
var comet = function() {
  $.ajax({
    type: 'GET',
    url:  '#{@path}',
    success: function(msg) {
      msg == 'reload' ? location.reload() : comet();
    }
  });
}
$(document).ready(comet);
  </script>
</head>
      LOCAL
  <script src='http://www.google.com/jsapi'></script>
  <script>
var comet = function() {
  $.ajax({
    type: 'GET',
    url:  '#{@path}',
    success: function(msg) {
      msg == 'reload' ? location.reload() : comet();
    }
  });
}

google.load('jquery', '1');
google.setOnLoadCallback(comet);
  </script>
</head>
      REMOTE
    end
  end
end
