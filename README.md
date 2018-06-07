# MusicKit GraphQL API Wrapper

Just a learning experiment to help understand both the MusicKit REST API and GraphQL. This is by no means feature complete, but you're welcome to fork and extend.

## Installation

Requirements:

* Ruby 2.x (I'm using Ruby 2.5, I haven't tested other versions)
* Bundler gem preinstalled (`gem install bundler`)

Install the bundled gems, I recommend using binstubs (`bundler install --binstubs`).

## Obtaining a MusicKit developer token

You'll need a MusicKit developer token to authenticate with the REST API.

Follow the [instructions outlined in the MusicKit documentation](https://developer.apple.com/documentation/applemusicapi/getting_keys_and_creating_tokens). Make a note of your key ID and your developer team ID, and download the `.p8` file to the `keys` directory in the project root. The GraphQL server will look for the first file with a `.p8` extension here. The contents of this directory are ignored by git.

## Starting the GraphQL server

The backend is a simple Sinatra app that serves the GraphQL schema at the `/graphql` endpoint.

The Gemfile includes the `foreman` and `puma` gems and a `Procfile` and `config.ru` file are supplied, so the server can be started using `foreman start web`.

You'll need to expose your key ID and team ID to the server using the environment variables `MUSICKIT_KEY_ID` and `MUSICKIT_TEAM_ID` respectively:

```
MUSICKIT_KEY_ID=abc MUSICKIT_TEAM_ID=123 foreman start web
```

## Testing the server

The simplest way to test the server is to use [graphiql](https://github.com/graphql/graphiql/). Simply point it at your endpoint (by default this will be http://localhost:9292/graphql) and start exploring.

Here's an example query:

```graphql
{
  artist(id: 302709189, storefront: "gb", include: ALBUMS) {
    id
    href
    type
    attributes {
      genreNames
    }
    relationships {
      albums {
        href
        data {
          id
          attributes {
            name
          }
        }
      }
    }
  }
}
```

The API has been designed to mirror the [MusicKit API reference](https://developer.apple.com/documentation/applemusicapi#//apple_ref/doc/uid/TP40017625-CH2-SW1) as closely as possible. The only entity in the MusicKit API reference excluded from returned results is the `ResponseRoot` object.
