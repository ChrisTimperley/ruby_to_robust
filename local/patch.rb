# Implements a local robustness patch.
#
# These patches are used to implement "softer" semantics in the program.
class Wallace::Local::Patch

  # Constructs a new patch.
  #
  # *Parameters:*
  # * binding, the class or module of the method that should be patched.
  # * name, the name of the method to be patched.
  # * backup, the name to store the old method under.
  # * replacement, the replacement method itself.
  def initialize(binding, name, backup, replacement)
    @binding = binding
    @name = name
    @backup = backup
    @replacement = replacement
  end

  # Applies this patch.
  def apply
    @binding.send(:alias_method, @backup, @name)
    @binding.send(:define_method, @name, @replacement)
  end

  # Removes this patch.
  def unapply
    @binding.send(:define_method, @name, @binding.method(@backup))
    @binding.send(:remove_method, @backup)
  end

end