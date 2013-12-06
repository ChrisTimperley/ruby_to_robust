# A fix atom is used to store and represent a single "atomic" change made by a candidate fix which
# may be represented as a collection of such atomic fixes.
class RubyToRobust::Global::Fix::Atom

  attr_reader :line_no

  # Constructs a new fix atom.
  #
  # *Parameters:*
  # * line_no, the line in the source code which the atom should operate on.
  def initialize(line_no)
    @line_no = line_no
  end

  # Destructively applies the change described by this atomic fix to the given source code.
  #
  # Rather than destructively operating on the source code we could return a modified copy,
  # but since we never need to operate on a new copy we save computational resources by
  # operating on the input source code directly. If you really wanted to create a new copy
  # then you could add a new method "apply" which simply passed a clone of its input to
  # the "apply!" method.
  #
  # *Parameters:*
  # * source, the source code of the affected method (represented as a sequence of lines).
  #
  # *Returns:*
  # The modified source code.
  def apply!(source)
    raise NotImplementedError, 'No "apply!" method was implemented by this Atom.'
  end

end