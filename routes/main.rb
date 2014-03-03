# encoding: utf-8

class MyApp < Sinatra::Application
  before do
    if session.empty?
      session['note'] = 'hi'
    end
  end

  get "/" do
    @title = "Home"
    haml :index
  end

  post "/game/new" do
    puts params
    @name = params[:name]
    @email = params[:email]
    u = Game.new(:name => @name, :email => @email)
    if u.valid?
      u.save
      redirect to("/game/#{u.token}/level1")
    else
      return 'Failure :('
    end
  end

  get "/game/:token" do
    g = Game.find(:token => params[:token])
    return g.name
  end

  get "/game/:token/level1" do
    g = Game.find(:token => params[:token])
    haml :'game/level1'
  end

  post "/game/:token/level1" do
    # prepare everyting
    locations = JSON.parse(params[:d])

    g = Game.find(:token => params[:token])
    g.adisk = locations
    g.run

  end

  get "/game/:token/status" do
    # this is an ajax request
    g = Game.find(:token => params[:token])

    return JSON.generate(g.status)

  end

  get "/game/:token/results" do

  end



end
