class Proc

  # Stores a definition of the procedure.
  @args = @body = nil

  # The type of robustness used by this procedure.
  @robust = nil

  # Specifies the source code of a dynamically created Proc (i.e. created via an
  # eval statement).
  #
  # *Parameters:*
  # * args, an array of the arguments to this Proc (REDUNDANT!).
  # * body, the body of this Proc.
  def set_source(args, body)
    @args = args
    @body = body
  end

  # Converts this Proc into a robust Proc.
  #
  # *Parameters:*
  # * type, type of robustness to be used (:global or :local).
  def to_robust(type)
    @robust = type
  end

  # Store the original procedure call method.
  alias_method :__call :call

  # Calls this procedure.
  #
  # *Parameters:*
  # * params, the parameters to this procedure.
  #
  # *Returns:*
  # The result of the procedure call.
  def call(*params)

    # If this procedure uses local robustness then 
    if @robust == :local
      RubyToRobust::Local.enable
      result = __call(*params)
      RubyToRobust::Local.disable
      return result
    
    # 
    elsif @robust == :global
      RubyToRobust::Global.enable
      result = __call(*params)
      RubyToRobust::Global.disable
      return result
    end


    # Otherwise return the original procedure call result.
    return __call(*params)

  end

end