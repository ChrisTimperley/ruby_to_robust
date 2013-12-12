# The swap method strategy is an abstract base strategy used by
# other strategies which operate by swapping a given method with
# an alternative which utilises soft semantics.
class ToRobust::Local::Strategies::SwapMethodStrategy < ToRobust::Local::Strategy

  # Constructs a new swap method strategy.
  #
  # *Parameters:*
  # * binding, the class or module of the method that should be patched.
  # * name, the name of the method to be patched.
  # * backup, the name to store the old method under.
  # * &replacement, the replacement method itself.
  def initialize(binding, name, backup, &replacement)
    @binding = binding
    @name = name
    @backup = backup
    @replacement = replacement
  end

  # Swaps the target method with its "softer" counterpart.
  def enable!
    @binding.send(:alias_method, @backup, @name)
    @binding.send(:define_method, @name, @replacement)
  end

  # Restores the target method to its original "hard" semantics.
  def disable!
    @binding.send(:define_method, @name, @binding.instance_method(@backup))
    @binding.send(:remove_method, @backup)
  end

end