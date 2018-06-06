require 'graphql'
require_relative 'query'

class MusicKitSchema < GraphQL::Schema.define
  query QueryType
end