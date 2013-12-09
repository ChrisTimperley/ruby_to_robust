# A remove atom is used to swap a line from the affected source code with another.
class RubyToRobust::Global::Fix::SwapAtom < RubyToRobust::Global::Fix::Atom

  # Constructs a new swap atom.
  #
  # *Parameters:*
  # * line_no, the line in the source code which the atom should operate on.
  # * replacement, the contents of the replacement line.
  def initialize(line_no, replacement)
    super(line_no)
    @replacement = replacement
  end

  # No lines are added.
  def lines_added; 0; end

  # Swaps the contents at specific line with an altered form stored by this object.
  #
  # *Parameters:*
  # * source, the (partially fixed) affected source.
  # * changes, an array of the atomic changes already applied to this source (in order of application).
  def apply!(source, changes)
    source[adjusted_line_no(changes)] = @replacement
  end

end