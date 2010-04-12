module Mascut
  class Mascut
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] =~ /^\/mascut$/
        mascut
      else
        status, headers, body = @app.call(env)
        if status == 200 and headers['Content-Type'] =~ /^text\/html/
          body = [ File.read(body.path) ] if body.is_a?(Rack::File)
          body.map! {|html| mascutize(html) }
          headers['Content-Length'] = body.to_ary.inject(0) { |len, part| len + Rack::Utils.bytesize(part) }.to_s
          
          [ status, headers, [mascutize(body.first)] ]
        else
          [ status, headers, body ]
        end
      end
    end

    def mascut
      now = Time.now
      files = Dir['**/*']
      
      catch :reload do
        loop do 
          files.each {|file| throw(:reload, 'reload') if File.exist?(file) and now < File.mtime(file) }
          sleep 1
        end
      end
      
      [ 200, { 'Cache-Control' => 'no-cache', 'Pragma' => 'no-cache', 'Content-Type' => 'text/plain' },  ['reload'] ]
    end

    def mascutize(html)
      # I don't use html parser like nokogiri, because it corrects html to be debugged
      html.sub('</head>', <<-JS)
  <script src='http://www.google.com/jsapi'></script>
  <script>
var comet = function() {
  $.ajax({
    type: 'GET',
    url:  '/mascut',
    success: function(msg) {
      msg == 'reload' ? location.reload() : comet();
    }
  });
}

google.load('jquery', '1');
google.setOnLoadCallback(comet);
  </script>
</head>
      JS
    end
  end
end
