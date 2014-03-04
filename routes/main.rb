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
    @firstname = params[:firstname]
    @email = params[:email]
    u = Game.new(:firstname => @firstname, :email => @email)
    if u.valid?
      u.save
      redirect to("/game/#{u.token}/level1")
    else
      return 'Failure :('
    end
  end

  get "/game/:token" do
    g = Game.find(:token => params[:token])
    return g.firstname
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

    redirect to("/game/#{g.token}/results")

  end

  get "/game/:token/status" do
    # this is an ajax request
    g = Game.find(:token => params[:token])

    return JSON.generate(g.status)

  end
  get "/game/:token/results" do
      haml :'game/results'
  end

  get "/game/:token/power" do
    g = Game.find(:token => params[:token])
    data = {:power => g.totalpower }
    return JSON.generate(data)
  end



end
