module RubyToRobust::Local::Strategies; end

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