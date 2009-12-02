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

  get %r{/(.+)} do |name|
    File.exist?(name) ? File.read(name) : halt(404)
  end
end

