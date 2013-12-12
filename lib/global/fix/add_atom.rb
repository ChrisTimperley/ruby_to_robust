# A add atom is used to insert a sequence of lines at a given position in the affected source code.
class ToRobust::Global::Fix::AddAtom < ToRobust::Global::Fix::Atom

  # Constructs a new add atom.
  #
  # *Parameters:*
  # * line_no, the line in the source code which the atom should operate on.
  # * additions, the sequence of lines to insert at the given line number (as an ordered array).
  def initialize(line_no, additions)
    super(line_no)
    @additions = additions
  end

  # Calculates and returns the number of lines added by the atom.
  def lines_added
    @additions.length
  end

  # Inserts a sequence of lines at specific line in the affected source code.
  #
  # *Parameters:*
  # * source, the (partially fixed) affected source.
  # * changes, an array of the atomic changes already applied to this source (in order of application).
  def apply!(source, changes)
    source.insert(adjusted_line_no(changes), *@additions)
  end

end