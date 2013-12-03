require_relative '../patches/method.rb'

module TestMethods
	def self.add(x,y); x+y; end
end

TestMethods.add(3,2)