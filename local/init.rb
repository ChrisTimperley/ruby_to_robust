require_relative 'local.rb'
require_relative 'patch.rb'

# Load the patches.
Dir[File.dirname(__FILE__) + '/patches/*.rb'].each { |file| require file }