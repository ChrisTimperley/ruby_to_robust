# Instances of this class are used to represent candidate fixes / solutions to given errors that
# have occurred during the execution of a method.
#
# A fix operates on the source code of a method, adding, removing and replacing specific lines of
# code (like a Git patch/change) in an attempt to remove the source of the error.
#
# As mentioned elsewhere in the Global module, strategies may return an ordered sequence of fixes
# according to the likelihood that they will solve the problem (or by their performance penalty to
# the method), but as this ordering is carried out by the strategies and all ordering information is
# implict, candidate fixes proposed by different solutions cannot be compared and ordered.
# 
# The ability to compare arbitrary fixes could be introduced by adding a notion of cost to each fix;
# a net quantification of both the performance penalty incurred to the method *after* applying the fix
# and the probability that the fix will be a good one (a good fix would have a lower cost than a worse
# fix). Candidate fixes could then be processed in ascending order of cost.
class ToRobust::Global::Fix

  # Creates a new candidate fix.
  #
  # *Parameters:*
  # * changes, an array of changes that the fix should make to the source code.
  # * validator, a lambda function that verifies a given error is not the same as the original error.
  def initialize(changes,validator)
    @changes = changes
    @validator = validator
  end

  # Calculates the source code of the fixed method using the atomic fixes described by this object.
  #
  # *Parameters:*
  # * src, the original source code (as lines) of the affected method.
  #
  # *Returns:*
  # The fixed source code for the method.
  def fixed_source(src)
    history = []
    @changes.each do |change|
      change.apply!(src, history)
      history << change
    end
    return src
  end

  # Applies the proposed changes to the source code of the affected method.
  #
  # *Parameters:*
  # * method, the affected method.
  #
  # *Returns*
  # A variant of the affected method modified according to the changes given by this fix.
  def apply(method)
    ToRobust::Global::RobustLambda.new(method.headers, fixed_source(method.source.dup[1...-1]).join('/\n/)'))
  end

  # In the event that the method resulting from the fix encounters an error, this method *attempts*
  # to determine whether the fix has been successful in removing the source of the original error.
  # A "fixed" method in this sense is not necessarily one which removes all errors from a given method,
  # rather it removes a particular identifiable error.
  #
  # *Parameters:*
  # * method, the affected method.
  # * original_error, the original error that was encountered by the method.
  # * new_error, the error encountered after applying this fix and executing the method again.
  #
  # *Returns:*
  # * True if the fix was successful in removing the cause of the original error, false if not.
  def successful?(method, original_error, new_error)
    @validator[method, original_error, new_error]
  end
  alias_method :validate, :successful?

end