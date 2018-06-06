class EditorialNotesType < GraphQL::Schema::Object
  description "Editorial notes, may include XML or special characters"

  field :short, String, null: false
  field :standard, String, null: false
end

class ArtistType < GraphQL::Schema::Object
  description "An artist in the Apple Music catalog"

  class AttributesType < GraphQL::Schema::Object
    field :name, String, null: false
    field :url, String, null: false
    # field :genreNames, [String], null: false
    field :editorialNotes, ::EditorialNotesType, null: true
  end

  field :type, String, null: false
  field :attributes, ArtistType::AttributesType, null: false
end
