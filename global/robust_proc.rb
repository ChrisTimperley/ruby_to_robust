# A robust procedure is a type of object which mimics the functionality of a standard lambda
# function but also adds line-specific error debugging information to exception traces.
class RubyToRobust::Global::RobustProc

  attr_reader :headers,
              :body,
              :source

  # Constructs a new Robust procedure.
  #
  # *Parameters:*
  # * headers, the arguments to the procedure (as an array of argument names).
  # * body, the body of the procedure.
  def initialize(headers, body)
    @headers = headers.freeze
    @body = body.freeze

    # Dynamically create the procedure as the "call" method of this object,
    # and supply file and line debugging information.
    @source = "def call(#{@headers.join(', ')})
  #{body}
end"
    instance_eval(@source, code, 0)
    @source = @source.lines.freeze
  end

  # Every robust procedure has its own unique code that is used as its source
  # file and is used to identify error information specific to it.
  def code
    "ROBUST_PROC_#{object_id}"
  end

end