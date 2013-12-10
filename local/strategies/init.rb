module RubyToRobust::Local::Strategies; end

# Load all the strategy definitions.
require_relative 'swap_method_strategy.rb'

require_relative 'numeric_division_strategy.rb'
require_relative 'numeric_modulus_strategy.rb'

require_relative 'bignum_division_strategy.rb'
require_relative 'bignum_modulus_strategy.rb'

require_relative 'fixnum_division_strategy.rb'
require_relative 'fixnum_modulus_strategy.rb'
require_relative 'fixnum_coerce_strategy.rb'

require_relative 'float_division_strategy.rb'
require_relative 'float_modulus_strategy.rb'

require_relative 'soft_binding_strategy.rb'

# Instantiate and attach each of them.
# This could be done automatically (following class definition) using
# the "defined" gem, but this may cause some compatibility issues.
RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::NumericDivisionStrategy.new
RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::NumericModulusStrategy.new

RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::BignumDivisionStrategy.new
RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::BignumModulusStrategy.new

RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::FixnumDivisionStrategy.new
RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::FixnumModulusStrategy.new
RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::FixnumCoerceStrategy.new

RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::FloatModulusStrategy.new
RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::FloatDivisionStrategy.new

RubyToRobust::Local.strategies << RubyToRobust::Local::Strategies::SoftBindingStrategy.new