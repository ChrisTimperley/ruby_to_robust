module RubyToRobust; end

require_relative 'kernel/init.rb'

require_relative 'local.rb'

# Load all the strategies.
require_relative 'strategy.rb'
require_relative 'strategies/init.rb'