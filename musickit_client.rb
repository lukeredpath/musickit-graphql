require 'faraday'
require 'faraday_middleware'

class MusicKitClient
  API_BASE_URL = 'https://api.music.apple.com/v1/'

  attr_reader :connection

  def initialize(auth_token)
    @connection = Faraday.new(url: API_BASE_URL) do |conn|
      conn.authorization :Bearer, auth_token
      conn.response :json,
        :content_type => /\bjson$/,
        :parser_options => { :symbolize_names => true }
      conn.adapter Faraday.default_adapter
    end
  end

  def storefronts
    fetch_response "storefronts"
  end

  def artist(id:, storefront:, include: [])
    path = "catalog/#{storefront}/artists/#{id}"
    path += "?include=#{include.join(',')}" if include && !include.empty?
    fetch_response path
  end

  private

  def fetch_response(path)
    ResponseRoot.new(@connection.get(path).body)
  end

  class ResponseRoot
    def initialize(json)
      @json = json
    end

    def data
      @json[:data]
    end
  end
end
