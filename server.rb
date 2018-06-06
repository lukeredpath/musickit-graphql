require 'sinatra'
require 'sinatra/json'
require 'rack/contrib'

require_relative 'keygen'
require_relative 'musickit_client'

keygen = MusicKitTokenGenerator.new(teamID: ENV['MUSICKIT_TEAM_ID'], keyID: ENV['MUSICKIT_KEY_ID'])

MUSICKIT_JWT_TOKEN = keygen.generate_encoded(keyFile: File.expand_path('./keys/AuthKey_2TJQ36CTNQ.p8'))

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

  get '/graphql' do
    json MusicKitSchema.execute(
      params[:query],
      variables: params[:variables],
      context: { },
    )
  end
end
