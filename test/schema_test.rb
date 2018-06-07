require 'minitest/autorun'
require 'mocha/minitest'
require 'json'

require_relative '../graphql/schema'

class SchemaTests < Minitest::Test
  def setup
    @gateway = mock('api gateway')
  end

  def test_can_get_simple_artist_attributes
    @gateway.stubs(:artist).with(id: '123', storefront: 'gb', include: []).returns(stub(data: [
        {
            "attributes": {
                "name": "Bruce Springsteen"
            },
            "href": "/v1/catalog/us/artists/178834",
            "id": "178834",
            "type": "artists"
        }
    ]))

    query = %|
    {
      artist(id: 123, storefront: "gb") {
        attributes {
          name
        }
      }
    }|

    result = execute(query, context: {gateway: @gateway})

    assert_equal 'Bruce Springsteen', result['data']['artist']['attributes']['name']
  end

  def test_can_get_list_attributes
    @gateway.stubs(:artist).with(id: '123', storefront: 'gb', include: []).returns(stub(data: [
        {
            "attributes": {
                "name": "Bruce Springsteen",
                "genreNames": ["Rock", "Pop"]
            },
            "href": "/v1/catalog/us/artists/178834",
            "id": "178834",
            "type": "artists"
        }
    ]))

    query = %|
    {
      artist(id: 123, storefront: "gb") {
        attributes {
          genreNames
        }
      }
    }|

    result = execute(query, context: {gateway: @gateway})

    assert_equal ['Rock', 'Pop'],  result['data']['artist']['attributes']['genreNames']
  end

  def test_can_get_albums_relationship
    data = [
        {
            "attributes": {
                "name": "Bruce Springsteen",
                "genreNames": ["Rock", "Pop"]
            },
            "href": "/v1/catalog/us/artists/178834",
            "id": "178834",
            "relationships": {
                "albums": {
                    "data": [
                        {
                            "href": "/v1/catalog/us/albums/1112053294",
                            "id": "1112053294",
                            "type": "albums"
                        },
                        {
                            "href": "/v1/catalog/us/albums/1083046086",
                            "id": "1083046086",
                            "type": "albums"
                        }
                    ],
                    "href": "/v1/catalog/us/artists/178834/albums",
                    "next": "/v1/catalog/us/artists/178834/albums?offset=25"
                }
            },
            "type": "artists"
        }
    ]

    @gateway.stubs(:artist).with(id: '123', storefront: 'gb', include: ['albums']).returns(stub(data: data))

    query = %|
    {
      artist(id: 123, storefront: "gb", include: ALBUMS) {
        relationships {
          albums {
            href,
            next,
            data {
              id
              href
            }
          }
        }
      }
    }|


    result = execute(query, context: {gateway: @gateway})

    assert_equal '/v1/catalog/us/artists/178834/albums', result['data']['artist']['relationships']['albums']['href']
    assert_equal '/v1/catalog/us/artists/178834/albums?offset=25', result['data']['artist']['relationships']['albums']['next']
    assert_equal '1112053294', result['data']['artist']['relationships']['albums']['data'][0]['id']
  end

  def test_can_get_related_album_attribute
    @gateway.stubs(:artist).with(id: '123', storefront: 'gb', include: ['albums']).returns(stub(data: [
        {
            "attributes": {
                "name": "Bruce Springsteen",
                "genreNames": ["Rock", "Pop"]
            },
            "href": "/v1/catalog/us/artists/178834",
            "id": "178834",
            "relationships": {
                "albums": {
                    "data": [
                        {
                            "href": "/v1/catalog/us/albums/1112053294",
                            "id": "1112053294",
                            "type": "albums",
                            "attributes": {
                              "name": "Born in the USA"
                            }
                        }
                    ],
                    "href": "/v1/catalog/us/artists/178834/albums",
                    "next": "/v1/catalog/us/artists/178834/albums?offset=25"
                }
            },
            "type": "artists"
        }
    ]))

    query = %|
    {
      artist(id: 123, storefront: "gb", include: ALBUMS) {
        relationships {
          albums {
            data {
              id,
              href,
              attributes {
                name
              }
            }
          }
        }
      }
    }|

    result = execute(query, context: {gateway: @gateway})

    assert_equal 'Born in the USA', result['data']['artist']['relationships']['albums']['data'][0]['attributes']['name']
  end

  private

  def execute(query, context: {}, variables: {})
    MusicKitSchema.execute(query, context: context, variables: variables)
  end

end
