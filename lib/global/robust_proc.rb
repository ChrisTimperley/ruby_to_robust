# A robust procedure is a type of object which mimics the functionality of a standard lambda
# function but also adds line-specific error debugging information to exception traces.
class ToRobust::Global::RobustProc

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

    # Store the lines of the body in the source property as an array (using chomp
    # to remove /n from the end of each line).
    @source = @source.lines.map(&:chomp).freeze

  end

  # Every robust procedure has its own unique code that is used as its source
  # file and is used to identify error information specific to it.
  def code
    "ROBUST_PROC_#{object_id}"
  end

  # Makes this robust procedure object take on the function of another
  # robust procedure. This allows repairs to be optionally saved.
  def become(other)
    @headers = other.headers
    @body = other.body
    @source = other.source
    instance_eval(@source.join("\n"), code, 0)
  end

end