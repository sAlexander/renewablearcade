# encoding: utf-8
require 'sinatra'
require 'haml'

class MyApp < Sinatra::Application
  use Rack::Session::Cookie, :key => 'SESSION_ID',
                             :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss',
                             :expire_after => 60*60*24*14 # == two weeks

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
    # ...
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
