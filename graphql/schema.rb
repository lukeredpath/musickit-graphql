require 'graphql'
require_relative 'query'

class MusicKitSchema < GraphQL::Schema
  query QueryType
end