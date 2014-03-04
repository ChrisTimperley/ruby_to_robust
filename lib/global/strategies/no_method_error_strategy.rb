require 'levenshtein'

# Handles NoMethodError exceptions by mapping missing method calls to valid replacement methods within
# the same module/class whose name is within a given Levenshtein distance of the missing method name.
class ToRobust::Global::Strategies::NoMethodErrorStrategy < ToRobust::Global::Strategy

  attr_accessor :max_distance

  # Constructs a new NoMethodErrorStrategy.
  #
  # *Parameters:*
  # * max_distance, the maximum allowed distance between an attempted and candidate method call.
  def initialize(max_distance = 5)
    @max_distance = max_distance
  end

  # Used to fix NoMethodError exceptions by replacing calls to missing methods with calls to
  # valid methods whose name is within a given Levenshtein distance of the missing method name.
  #
  # *Parameters:*
  # * method, the affected method.
  # * error, the error whose root cause should be fixed.
  #
  # *Returns:*
  # A (possibly empty) array of candidate fixes to the root cause of the error.
  def generate_candidates(method, error)

    # Ensure that the error is a NoMethodError.
    return [] unless error.is_a? NoMethodError

    # Retrieve details of the missing method and the contents of the line that the error
    # occurred on.
    line_no = error.line_no
    line_contents = method.source[line_no]
    missing_method_name = error.method_name
    missing_method_owner = error.method_owner
    
    # "main" methods aren't dealt with since there are too many dangerous replacement methods
    # contained within main.
    return [] if missing_method_owner.empty?
    
    # Check if the missing method belongs to a module or a class.
    missing_method_owner = missing_method_owner.partition(':')
    missing_method_owner_type = missing_method_owner[2]
    
    # Check if the missing method belongs to neither a module nor class (this
    # shouldn't happen).
    return [] unless ['Class', 'Module'].include? missing_method_owner_type
    
    # Retrieve the object for the class / module.
    missing_method_owner = Kernel.const_get(missing_method_owner[0])
    
    # Extract a list of candidate methods from the class / module and calculate
    # their levenshtein distance to the missing method. Before calculating the levenshtein
    # distance to candidates, throw away any candidates whose difference in length with
    # the requested method is greater than the maximum distance (since it is impossible
    # that their levenshtein distance can be less or equal to the maximum distance).
    if missing_method_owner_type == 'Module'
      candidates = missing_method_owner.singleton_class.public_instance_methods(false)
    else
      candidates = missing_method_owner.public_instance_methods(false)
    end

    candidates.reject!{|c| (c.length - missing_method_name.length).abs > @max_distance}
    candidates.map!{|c| [c.to_s, Levenshtein.distance(missing_method_name, c.to_s)]}
    
    # Only keep candidates whose distance with the missing
    # method is less or equal to the threshold. Order the remaining candidates
    # before throwing away the distance information.
    candidates.reject!{|c| c[1] > @max_distance}
    candidates.sort! {|x,y| 
      x[1] <=> y[1]
    }
    candidates.map!{|c| c[0]}
    
    # We validate the exception by ensuring that any further exceptions aren't
    # NoMethodError exceptions for the fixed method on the fixed line.
    validator = lambda do |method, old_error, new_error|
      return (not (new_error.is_a? NoMethodError and new_error.method_name == old_error.method_name and new_error.line_no == old_error.line_no))
    end

    # Compose each candidate into a fix by replacing each occurence of the
    # missing method name in the string with the name of the candidate method.
    return candidates.map! do |c|
      fixed_line = line_contents.gsub(/(\(|^|::|\.|\s|,)#{missing_method_name}\(/) {|s| s[missing_method_name] = c; s}
      ToRobust::Global::Fix.new(
        [ToRobust::Global::Fix::SwapAtom.new(line_no, fixed_line)],
        validator
      )
    end

  end

end