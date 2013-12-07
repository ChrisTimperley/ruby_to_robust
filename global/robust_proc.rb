# A robust procedure is a type of object which mimics the functionality of a standard lambda
# function but also adds line-specific error debugging information to exception traces.
class RubyToRobust::Global::RobustProc

  attr_reader :headers,
              :body

  # Constructs a new Robust procedure.
  #
  # *Parameters:*
  # * headers, the arguments to the procedure (as an array of argument names).
  # * body, the body of the procedure.
  def initialize(headers, body)
    @headers = headers
    @body = body

    # Dynamically create the procedure as the "call" method of this object,
    # and supply file and line debugging information.
    instance_eval("def call(#{@headers.join(', ')})
  #{body}
end", 'ROBUST_PROC', 0)

  end

end