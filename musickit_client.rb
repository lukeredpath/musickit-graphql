require 'faraday'
require 'faraday_middleware'

class MusicKitClient
  API_BASE_URL = 'https://api.music.apple.com/v1/'

  attr_reader :connection

  def initialize(auth_token)
    @connection = Faraday.new(url: API_BASE_URL) do |conn|
      conn.authorization :Bearer, auth_token
      conn.response :json, :content_type => /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end

  def storefronts
    fetch_json "storefronts"
  end

  private

  def fetch_json(path)
    @connection.get(path).body
  end
end
