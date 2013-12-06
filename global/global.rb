# The Global robustness module implements a simplified (and faster) variant of the global
# robustness measure outlined in Chris Timperley's Master's Thesis.
#
# Methods executed under global robustness protection are executed within an exception
# catching block which intercept any errors which cause the method to fail 
#
# For now this measure only works with simple methods that do not change the state of 
# objects or interfere with the global state.
#
# NEED TO CLONE PARAMETERS.
#
# Author: Chris Timperley
module RubyToRobust::Global

  # Optimism setting could be used to attempt to execute the program before
  # converting it to a static method (would save a lot of time!).
  class << self
    attr_accessor :optimistic
  end

  # Executes a given method (or proc) under global robustness protection.
  #
  # *Parameters:*
  # * method, the method to execute using global robustness protection.
  # * params, the parameters to the method call.
  #
  # *Returns:*
  # The result of the method call.
  def self.execute(method, params)

    # Convert the provided method to a statically defined method if it isn't one already.
    # This allows us to probe line information from exceptions thrown within the method.
    # If the method is already statically defined, then we create and operate on a copy of
    # the method so that changes are localised to the method call.
    method = method.to_static

    # Attempt to execute the method. If an error occurs then attempt to repair the method
    # using the error information. Once repaired attempt to call the method again, repeating
    # the cycle, until either the method successfully returns a result or a maximum number of
    # errors occur.
    until REPAIR_LIMIT
      begin
        return method.call(*params)
      rescue => error
        method = repair(method, params, error)
      end
    end

  end

  # Calculates all the possible candidate fixes to a given error within a provided method.
  # Passes the details of the error along with the method to each associated error handling
  # strategy and queries all possible candidate solutions.
  #
  # *TODO:*
  # At the moment each strategy may return an ordered set of candidate fixes to the problem,
  # but this ordering information is implicit (and usually not universally comparable) so there
  # can be no ordering of candidate fixes from ALL given strategies (i.e. strategy B may produce
  # a strategy that is more likely to solve the error than the best candidate given by strategy A).
  #
  # *Parameters:*
  # * method, the method to be fixed.
  # * error, the error to be addressed.
  #
  # *Returns:*
  # An array of candidate fixes to the error.
  def self.candidates(method, error)
    @strategies.map { |c| c.candidates(method, error) }.flatten
  end

  # Repairs a given (statically defined) method using the details of an encountered error.
  #
  # Special care must be taken to define repair. In this context, a repaired method
  # is one which does not suffer from the same error that it did originally. This means
  # that the repaired form of the provided method may still contain errors.
  #
  # This definition of repair is necessary to fix methods which contain more than a single
  # error.
  #
  # *Parameters:*
  # * method, the broken method to be repaired.
  # * params, the parameters to the original method call.
  # * error, the error that occurred when the method was called.
  #
  # *Returns:*
  # A repaired form of the method.
  def self.repair(method, params, error)

    # Produce a series of candidate fixes to the method.
    # WOULD BE *POTENTIALLY* FASTER IF THIS WAS ORDERED!
    candidates = []

    # Attempt each of the candidate fixes until the error is prevented or there are no
    # further candidates to try.
    until candidates.empty?

      fix = candidates.shift
      fix_method = fix.apply(method)

      begin
        fix_method.call(*params.clone)
        return fix_method
      rescue => fix_error
        return fix if fix.successful?(error, fix_error)
      end

    end

    # If all attempts to repair the method against the given error fail then re-throw
    # the exception.
    raise error

  end

end