require 'sinatra/base'
require 'chip8'

module Chip8
  class WebDebug < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/web_debug/views"
    set :public_folder, "#{dir}/web_debug/public"
    set :static, true
    set :method_override, true

    get '/' do
      erb :index
    end
  end
end
