# A remove atom is used to remove a line from the affected source code.
class Wallace::Global::Fix::RemoveAtom < Wallace::Global::Fix::Atom

  # Removes a single line from the source code.
  def lines_added; -1; end

  # Removes a specific line from the affected source code and returns the result.
  #
  # *Parameters:*
  # * source, the (partially fixed) affected source.
  # * changes, an array of the atomic changes already applied to this source (in order of application).
  def apply!(source, changes)
    source.delete_at(adjusted_line_no(changes))
    changes << self
  end

end