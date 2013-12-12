# A report is used to hold the details of a successful repair attempt along with
# the (partially) fixed method.
# 
# If a repair was partially successful (i.e. it removed the cause of the original
# error but not all errors) then the report holds the next error that should
# be resolved.
#
# If a repair was completely succesful (i.e. the method executed without throwing
# any exceptions) then the report is used to hold the result of the method call.
#
# The storage of error and result by the report is exploited by the repair-cycle
# to prevent redundant method calls.
class ToRobust::Global::Report

  attr_reader :fixed_method,
              :result,
              :error

  # Creates a new report.
  #
  # *Parameters:*
  # * fixed_method, the fixed form of the method.
  # * opts, a hash of keyword options for this constructor.
  #   -> result, the result of the method call (if the repair was a complete success).
  #   -> error, the error encountered when calling the method after repair (if the repair was a partial success).
  def initialize(fixed_method, opts = {})
    @fixed_method = fixed_method
    @result = opts[:result]
    @error = opts[:error]
  end

  # Returns true if the repair completely fixed the method (removing all errors).
  def complete?
    @error.nil?
  end

  # Returns true if there were still further (unrelated) errors after fixing the method.
  def partial?
    not complete?
  end

end