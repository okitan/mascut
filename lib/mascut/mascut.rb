require 'sinatra/base'

module Mascut
  class Mascut < Sinatra::Base
    get '/mascut' do
      headers 'Cache-Control' => 'no-cache', 'Pragma' => 'no-cache'
      
      now = Time.now
      files = Dir['**/*']
      
      catch :reload do
        loop do 
          files.each {|file| throw(:reload, 'reload') if File.exist?(file) and now < File.mtime(file) }
          sleep 1
        end
      end
    end
    
    get %r{^/(.+\.html)$} do |name|
      halt(404) unless File.exist?(name)
      
      # I don't use nokogiri because it corercts wrong html.
      File.read(name).sub('</head>', <<-JS)
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
    
    get %r{^/(.+\.css)$} do |name|
      content_type :css
      File.exist?(name) ? File.read(name) : halt(404)
    end
  end
end
