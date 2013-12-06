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
class RubyToRobust::Global::Fix

  # Creates a new candidate fix.
  #
  # *Parameters:*
  # * changes, an array of changes that the fix should make to the source code.
  # * validator, a lambda function that verifies a given error is not the same as the original error.
  def initialize(changes, &validator)
    @changes = []
    @validator = validator
    # Atom(line)
    # RemoveAtom < Atom
    # AddAtom(line, new) < Atom
    # SwapAtom(line, new) < Atom
  end

  # Applies the proposed changes to the source code of the affected method.
  #
  # *Parameters:*
  # * method, the affected method.
  #
  # *Returns*
  # A variant of the affected method modified according to the changes given by this fix.
  def apply(method)
    method
  end

  # In the event that the method resulting from the fix encounters an error, this method *attempts*
  # to determine whether the fix has been successful in removing the source of the original error.
  # A "fixed" method in this sense is not necessarily one which removes all errors from a given method,
  # rather it removes a particular identifiable error.
  def successful?(method, original_error, new_error)
    @validator[method, original_error, new_error]
  end
  alias_method :validate :successful?

end