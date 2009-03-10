# Needed to import datamapper and other gems
require 'rubygems'
require 'pathname'

# Add all external dependencies for the plugin here
gem 'dm-core'
require 'dm-core'

# Require plugin-files
require Pathname(__FILE__).dirname.expand_path/'dm-is-serialized'/'is'/'serialized'

# Include the plugin in Resource
module DataMapper
  module Model
    include DataMapper::Is::Serialized
  end
end
