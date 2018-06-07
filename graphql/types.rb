require_relative 'types/core'

module Types
  autoload :Artist,         File.join(File.dirname(__FILE__), *%w[types artist])
  autoload :Album,          File.join(File.dirname(__FILE__), *%w[types album])
  autoload :EditorialNotes, File.join(File.dirname(__FILE__), *%w[types editorial_notes])
end
