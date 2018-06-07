module Types
  class Artist < Resource
    description "An artist in the Apple Music catalog"

    class Attributes < GraphQL::Schema::Object
      graphql_name "ArtistAttributes"

      field :name, String, null: false
      field :url, String, null: false
      field :genre_names, [String], null: false, hash_key: :genreNames
      field :editorial_notes, Types::EditorialNotes, null: true
    end

    class Relationships < GraphQL::Schema::Object
      graphql_name "ArtistRelationships"

      field :albums, Relationship[Types::Album], null: false
    end

    class IncludeKeys < GraphQL::Schema::Enum
      graphql_name "ArtistRelationshipIncludeKeys"

      value "ALBUMS", "Include the full album attributes", value: 'albums'
      value "GENRES", "Include the full genre attributes", value: 'genres'
    end

    field :type, String, null: false
    field :attributes, Artist::Attributes, null: true
    field :relationships, Artist::Relationships, null: true
  end
end
