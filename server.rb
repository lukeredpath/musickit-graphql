require 'sinatra'

class MusicKitGraphQLServer < Sinatra::Base
  get '/' do
    "Server is running"
  end
end