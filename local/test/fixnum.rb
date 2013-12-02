require_relative '../../init.rb'

div = lambda { |x, y| x / y }

puts RubyToRobust::Local.execute(div, [1.0, 2.0])