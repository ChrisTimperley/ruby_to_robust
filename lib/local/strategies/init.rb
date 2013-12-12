module ToRobust::Local::Strategies; end

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
ToRobust::Local.strategies << ToRobust::Local::Strategies::NumericDivisionStrategy.new
ToRobust::Local.strategies << ToRobust::Local::Strategies::NumericModulusStrategy.new

ToRobust::Local.strategies << ToRobust::Local::Strategies::BignumDivisionStrategy.new
ToRobust::Local.strategies << ToRobust::Local::Strategies::BignumModulusStrategy.new

ToRobust::Local.strategies << ToRobust::Local::Strategies::FixnumDivisionStrategy.new
ToRobust::Local.strategies << ToRobust::Local::Strategies::FixnumModulusStrategy.new
ToRobust::Local.strategies << ToRobust::Local::Strategies::FixnumCoerceStrategy.new

ToRobust::Local.strategies << ToRobust::Local::Strategies::FloatModulusStrategy.new
ToRobust::Local.strategies << ToRobust::Local::Strategies::FloatDivisionStrategy.new

ToRobust::Local.strategies << ToRobust::Local::Strategies::SoftBindingStrategy.new