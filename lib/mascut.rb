require 'sinatra/base'

class Mascut < Sinatra::Base
  def monitor
    now = Time.now
    files = Dir['**/*']
    
    loop do 
      files.each {|file| return 'reload' if File.exist?(file) and now < File.mtime(file) }
      sleep 1
    end
  end
  
  get '/mascut' do
    monitor
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
google.setOnLoadCallback(function() {
  comet();
});
  </script>
</head>
    JS
  end

  get %r{^/(.+\.css)$} do |name|
    content_type :css
    File.exist?(name) ? File.read(name) : halt(404)
  end
end

