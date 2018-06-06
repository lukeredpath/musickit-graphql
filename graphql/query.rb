require 'graphql'
require_relative 'types'

module MusicKitClientFromContext
  def client
    jwt_token = context[:jwt_token]
    raise RuntimeError.new("JWT token must be passed in the context") unless jwt_token
    MusicKitClient.new(jwt_token)
  end
end

class QueryType < GraphQL::Schema::Object
  include MusicKitClientFromContext

  description "The query root of this schema"

  field :artist, ArtistType, null: true do
    description "Find an artist by ID in a particular storefront"

    argument :id, ID, required: true
    argument :storefront, String, required: true
  end

  def artist(id:, storefront:)
    client.artist(id: id, storefront: storefront).data.first
  end
end
