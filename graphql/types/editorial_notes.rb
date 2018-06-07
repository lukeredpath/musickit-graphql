module Types
  class EditorialNotes < GraphQL::Schema::Object
    description "Editorial notes, may include XML or special characters"

    field :short, String, null: false
    field :standard, String, null: false
  end
end
