require 'levenshtein'

# Exploits the 'method_missing' hook to implement a custom message passing protocol.
#
# All methods for each associated context are hidden by prepending their names with "__" and
# making them private. These hidden methods can later be accessed using the "hidden_methods"
# method on an associated context.
#
# All method calls will fire the 'method_missing' callback, since the method is no longer
# attached to the object at the original address. The method missing callback then inspects the
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
class ToRobust::Local::Strategies::SoftBindingStrategy < ToRobust::Local::Strategy

  # Allow the maximum acceptable Levenshtein distance to a candidate method to be
  # adjusted.
  @max_distance = 5
  class << self
    attr_accessor :max_distance
  end

  # Caches the list of contexts for later use.
  def prepare!(contexts)
    @contexts = contexts
  end

  # Hides all methods attached to each context (by prepending their names with "__" and making
  # them private) before attaching a method missing handler to each of the contexts.
  def enable!
    @contexts.each do |c|
      c.hide_methods!
      c.singleton_class.send(:define_method, :method_missing) do |method_name, *args, &block|

        # Convert the method symbol to a string, ready for lookup.
        method_name = method_name.to_s

        # Maximum levenshtein distance allowed between a candidate and the requested method.
        max_distance = RubyToRobust::Local::Strategies::SoftBindingStrategy.max_distance

        # Cache the list of candidate methods.
        candidates = hidden_methods

        # If no method exists with the given name then find the method with the closest
        # name (measured by levenshtein distance). Only consider candidates whose distance
        # to the requested method is less or equal to the maximum distance.
        unless candidates.key? method_name

          best_candidate = nil
          best_score = nil
          candidates.each_key do |cname|
          
            # Only calculate the distance if the difference in length between the requested
            # and candidate methods is less or equal to the maximum distance.
            unless (cname.length - method_name.length).abs > max_distance
              distance = Levenshtein.distance(cname, method_name)
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
        method = candidates[method_name]
          
        # If no arguments are provided and the arity of this method is greater than zero,
        # then return zero.
        return 0 if method.arity > 0 and args.length == 0

        # If fewer arguments than necessary are provided then pad the arguments with zeros.
        args = args.fill(0, args.length...method.arity) if method.arity > args.length

        # If more arguments than necessary are provided, restrict them to the function's
        # arity.
        args = args.first(method.arity) if method.arity != -1 and args.length > method.arity

        # Call the method with the filtered arguments.
        return method.call(*args)

      end
    end
  end

  # Restores all the hidden methods to their previous state and removes the method missing
  # handler from each associated context.
  def disable!
    @contexts.each do |c|
      c.unhide_methods!
      c.singleton_class.send(:remove_method, :method_missing)
    end
  end

end