module Types
  class Resource < GraphQL::Schema::Object
    field :href, String, null: true
    field :id, ID, null: false
    field :type, String, null: false
  end

  class Relationship
    def self.[](resource_type)
      GraphQL::ObjectType.define do
        name "#{resource_type.name.split("::").last}Relationship"
        field :href, types.String do
          resolve ->(obj, _, _) { obj[:href] }
        end
        field :next, types.String do
          resolve ->(obj, _, _) { obj[:next] }
        end
        field :data, types[resource_type] do
          resolve ->(obj, _, _) { obj[:data] }
        end
      end
    end
  end
end
