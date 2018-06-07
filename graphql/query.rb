require 'graphql'
require_relative 'types'

class QueryType < GraphQL::Schema::Object
  description "The query root of this schema"

  field :artist, Types::Artist, null: true do
    description "Find an artist by ID in a particular storefront"

    argument :id, ID, required: true,
      description: "The artist's catalog ID."

    argument :storefront, String, required: true,
      description: "The storefront catalog to be searched."

    argument :include, [Types::Artist::IncludeKeys], required: false,
      description: "Specifies which nested resources should be fully included in the response."
  end

  def artist(id:, storefront:, include: [])
    gateway.artist(id: id, storefront: storefront, include: include).data.first
  end

  private

  def gateway
    context[:gateway]
  end
end
