module Types
  class Album < Resource
    description "An album in the Apple Music catalog"

    class Attributes < GraphQL::Schema::Object
      graphql_name "AlbumAttributes"

      field :name, String, null: false, hash_key: :name
    end

    field :type, String, null: false
    field :attributes, Album::Attributes, null: true
  end
end
