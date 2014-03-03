# encoding: utf-8
require 'sinatra'
require 'sinatra/sequel'
configure :development do
  set :database, 'sqlite://development.db'
end

configure :test do
  set :database, 'sqlite::memory'
end

require_relative 'game'
require_relative 'migrate'
