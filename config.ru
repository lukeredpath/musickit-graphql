require './server'

unless ENV['MUSICKIT_TEAM_ID']
  raise "MUSICKIT_TEAM_ID environment variable must be set!"
end

unless ENV['MUSICKIT_KEY_ID']
  raise "MUSICKIT_KEY_ID environment variable must be set!"
end

run MusicKitGraphQLServer