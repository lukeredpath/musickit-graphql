require 'graphql'

class QueryType < GraphQL::Schema::Object do
  description "The query root of this schema"

end