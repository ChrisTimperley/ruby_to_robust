# Instances of this class are used to represent candidate fixes / solutions to given errors that
# have occurred during the execution of a method.
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
  def initialize

  end

  # Applies the proposed changes to the source code of the affected method.
  #
  # *Returns*
  # Could return an altered form of the method rather than changing the actual method?
  # Although more (initially) expensive in terms of memory it removes the need for unapply and
  # reduces the overall complexity of the process.
  def apply!

  end

  # Reverts the changes made by this candidate fix, returning the affected source code to its
  # prior state.
  def unapply!

  end
  alias :revert :unapply

  # In the event that the method resulting from the fix encounters an error, this method *attempts*
  # to determine whether the fix has been successful in removing the source of the original error.
  # A "fixed" method in this sense is not necessarily one which removes all errors from a given method,
  # rather it removes a particular identifiable error.
  def successful?

  end

end