require 'sinatra'
require 'sinatra/json'
require 'rack/contrib'

require_relative 'keygen'
require_relative 'musickit_client'
require_relative 'graphql/schema'

keygen = MusicKitTokenGenerator.new(teamID: ENV['MUSICKIT_TEAM_ID'], keyID: ENV['MUSICKIT_KEY_ID'])

unless key_file = Dir['keys/*.p8'].first
  raise "Could not find a p8 key file in the keys directory!"
end

MUSICKIT_JWT_TOKEN = keygen.generate_encoded(key_file: key_file)

class MusicKitGraphQLServer < Sinatra::Base
  use Rack::PostBodyContentTypeParser

  def client
    @client ||= MusicKitClient.new(MUSICKIT_JWT_TOKEN)
  end

  get '/' do
    "Server is running"
  end

  get '/storefronts' do
    # a simple proxy to test its working
    json client.storefronts
  end

  post '/graphql' do
    json MusicKitSchema.execute(
      params[:query],
      variables: params[:variables],
      context: { gateway: client },
    )
  end
end
