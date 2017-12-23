require 'sinatra/base'
require "sinatra/json"
require 'json'
require './lib/address.rb'
Dir['./lib/*/*.rb'].each { |f| require f }
require 'pry'
class Main < Sinatra::Base
  helpers AssetsHelpers

  get '/' do
    erb :index #, locals: { address: address }
  end

  post '/address' do
    coordinates = JSON.parse(request.body.read)
    address = Address.new(lat: coordinates['lat'], lng: coordinates['lng'])

    address.geocode!
    distance_to_whitehouse = address.miles_to([38.8987653, -77.037098])
    p distance_to_whitehouse
    if address.errors.any?
      status 502
      json errors: address.errors
    else
      json address: address.full_address, lat: address.lat, lng: address.lng, distance_to_whitehouse: distance_to_whitehouse
    end
  end
end
