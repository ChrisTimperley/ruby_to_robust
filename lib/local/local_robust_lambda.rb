# encoding: utf-8
#
# A robust procedure is a type of object which mimics the functionality of a standard lambda
# function but also adds line-specific error debugging information to exception traces.
class ToRobust::Local::LocalRobustLambda

  # The headers (arguments) for this lambda function.
  attr_reader :headers,

  # The body of this lambda function.
              :body,

  # The source code for this lambda function.
              :source,

  # A list of contexts objects that are protected during this function call.
              :contexts

  # Constructs a new Local Robust lambda function.
  #
  # ==== Parameters
  # [+headers+]   the arguments to the lambda function (as an array of argument names).
  # [+body+]      the body of the lambda function.
  # [+contexts+]  a list of contexts protected by this function.
  def initialize(headers, body, contexts)
    
    @contexts = contexts
    @headers = headers.freeze
    @body = body.freeze
    @source = "def call(#{@headers.join(', ')})
  #{body}
end".freeze
  
    # Compose the actual lambda function.
    @lambda = eval("lambda { |#{headers.join(', ')}| #{body}}")

  end

  # Calls this robust lambda function (under local robustness protection)
  # and returns the result.
  #
  # ==== Parameters
  # [+*args+]      a depickled list of arguments to the function.
  #
  # ==== Returns
  # The result of the function call.
  def [](*args)
    ToRobust::Local.protected(*contexts) { @lambda[*args] }
  end
  alias_method :call, :[]

end
