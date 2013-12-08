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

  @strategies = []
  @max_attempts = 10
  @save_repairs = true

  class << self

    # A flag to control whether repairs to a method should be permanent (true) or if they
    # should last only for a given call (false).
    # True by default.
    attr_accessor :save_repairs

    # The maximum number of (different) errors that will be tolerated before
    # all attempts to repair the method are ceased.
    # 10 by default.
    attr_accessor :max_attempts

    # Allow strategies to be added and removed via:
    # * Global.strategies << Strategy.new
    # * Global.strategies.remove(strategy)
    attr_reader :strategies

  end

  # Executes a given method (or proc) under global robustness protection.
  #
  # *Parameters:*
  # * method, the (robust proc) method to execute using global robustness protection.
  # * params, the parameters to the method call.
  #
  # *Returns:*
  # The result of the method call.
  def self.execute(method, params)

    # Attempt to execute the method. If an error occurs then attempt to repair the method
    # using the error information.
    attempts = 0
    begin
      return method.call(*params.clone)
    rescue => original_error
      report = repair(method, params, original_error)
      attempts += 1
    end

    # Once repaired attempt to call the method again, repeating the cycle,
    # until either the method successfully returns a result or a maximum number of errors occur.
    until attempts >= @max_attempts or report.complete?
      attempts += 1
      report = repair(report.method, params, report.error)
    end

    # If the repair limit has been hit then return the original error and make no permanent
    # changes to the supplied method (or should we keep the changes?).
    raise original_error if report.partial?

    # If the method was completely repaired then swap the original method with the fixed form
    # (so long as that functionality is enabled) and return the result of the method call.
    method.become(report.fixed_method) if @save_repair
    return report.result

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
  def self.generate_candidates(method, error)
    @strategies.map { |s| s.generate_candidates(method, error) }.flatten
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
    candidates = generate_candidates(method, error)

    # Attempt each of the candidate fixes until the error is prevented or there are no
    # further candidates to try.
    until candidates.empty?

      fix = candidates.shift
      fixed_method = fix.apply(method)

      begin
        result = fixed_method.call(*params.clone)
        return Report.new(fixed_method, result: result)
      rescue => fix_error
        return Report.new(fixed_method, error: fix_error) if fix.successful?(error, fix_error)
      end

    end

    # If all attempts to repair the method against the given error fail then re-throw
    # the exception.
    raise error

  end

  # Executes a given block whilst preventing a ZeroDivisionError occurring.
  # If a zero division error does occur during the execution of the block, this safety
  # wrapper will catch the exception and will return a zero instead, allowing the program
  # to continue.
  #
  # *Parameters:*
  # * &block, the block to execute under ZeroDivisionError protection.
  #
  # *Returns:*
  # The result of the block execution, or zero if the block execution yields a ZeroDivisionError.
  def self.prevent_dbz(&block)
    begin
      return &block.call
    rescue ZeroDivisionError
      return 0
    end
  end

end