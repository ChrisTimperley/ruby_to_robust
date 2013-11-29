# Exploits the 'method_added' and 'method_missing' hooks to implement a custom
# message passing protocol.
#
# All added methods are stored in an internal array before being removed from the object.
#
# Thereafter all calls to the given method will fire the 'method_missing' callback, since the
# method is no longer attached to the object. The method missing callback then inspects the
# method call and attempts to find the nearest method to that which was requested (based
# on the Levenshtein distance between the requested method and a candidate method).
#
# This way method calls like 'ad(3,2)' and 'adda(3,2)' would map to 'add(3,2)', giving methods
# a soft binding.
#
# If the nearest method has an arity which does not match the number of parameters supplied to
# the method call, then:
# * If there are too few parameters, pad the list with zeroes (arbitrary choice!).
# * If there are too many parameters, restrict the length of the list to the arity of the method.
class Module

  # Stores added methods in an internal method store before removing them from the object.
  #
  # *Parameters:*
  # * method_symbol, the symbol of the added method.
	def method_added(method_symbol)
		
		# Check that the method isn't forbidden.
		return if [:method_missing, :method_added].include? method_symbol
		
		# Create the method dictionary for this class/module if it
		# hasn't been created already.
		@methods = {} unless defined? @methods
		
		# Extract the method from the class and store it in the
		# private dictionary using the string form of the method name as the key.
		method = instance_method(method_symbol)
		@methods[method_symbol.to_s] = method
		
		# Remove the method from the class.
		method.owner.instance_eval { remove_method(method_symbol) }
		
	end

	# Called on every user-added method invocation, since these methods are
	# removed by method_added.
  #
  # *Parameters:*
  # * method_name, the name of the method that was called (as a symbol).
  # * args, a list of the arguments supplied with the method call.
  # * block, the block attached to the method call.
  #
  # *Return:*
  # The result of the matched method call.
	def method_missing(method_name, *args, &block)
	
		# Maximum levenshtein distance allowed between a candidate and the requested method.
		max_distance = 5
	
		# Convert the method symbol to a string, ready for lookup.
		method_name = method_name.to_s
		
		# If no method exists with the given name then find the method with the closest
		# name (measured by levenshtein distance). Only consider candidates whose distance
		# to the requested method is less or equal to the maximum distance.
		unless @methods.key? method_name

			best_candidate = nil
			best_score = nil
			@methods.each_key do |cname|
			
				# Only calculate the distance if the difference in length between the requested
				# and candidate methods is less or equal to the maximum distance.
				unless (cname.length - method_name.length).abs > max_distance
					distance = Text::Levenshtein.distance(cname, meth)
					if distance <= max_distance and (best_score.nil? or distance < best_score)
						best_candidate = cname
						best_score = distance
					end
				end
			end
			
			# Attempt to call the best candidate.
			# If no appropriate candidate is found, raise a NoMethodError.
			raise NoMethodError if best_candidate.nil?
			method_name = best_candidate
		
		end
	
		# Retrieve the method object for the selected method.
		method = @methods[method_name]
			
		# If no arguments are provided and the arity of this method is greater than zero,
		# then return zero.
		return 0 if method.arity > 0 and args.length == 0
		
		# If fewer arguments than necessary are provided then pad the arguments with zeros.
		args = args.fill(0, args.length...method.arity) if method.arity > args.length
		
		# If more arguments than necessary are provided, restrict them to the function's
		# arity.
		args = args.first(method.arity) if method.arity != -1 and args.length > method.arity
		
		# Call the method with the filtered arguments.
		return method.bind(self).call(*args)
		
	end

end