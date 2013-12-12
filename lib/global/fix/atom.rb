# A fix atom is used to store and represent a single "atomic" change made by a candidate fix which
# may be represented as a collection of such atomic fixes.
class ToRobust::Global::Fix::Atom

  # The line which this atomic fix changes.
  attr_reader :line_no

  # Constructs a new fix atom.
  #
  # *Parameters:*
  # * line_no, the line in the source code which the atom should operate on.
  def initialize(line_no)
    @line_no = line_no
  end

  # Calculates the number of lines that will be added by this fix.
  def lines_added
    raise NotImplementedError, 'No "lines_added" method was implemented by this Atom.'
  end

  # Calculate the line number in the adjusted source code that corresponds to the specified
  # line in the body of the original source code.
  #
  # *Parameters:*
  # * changes, an array of the atomic changes already applied to this source.
  def adjusted_line_no(changes)
    
    adj_n = @line_no
    changes.each do |c|
      if c.line_no < @line_no and lines_added < 0
        adj_n += c.lines_added
      elsif c.line_no >= line_no and lines_added > 0
        adj_n += c.lines_added
      end
    end

    # Subtract one to return the line number in the body (header takes up the first line).
    return adj_n - 1

  end

  # Destructively applies the change described by this atomic fix to the given source code.
  #
  # *Parameters:*
  # * source, the source code of the affected method (represented as a sequence of lines).
  # * changes, an array of the atomic changes already applied to this source (in order of application).
  def apply!(source, changes)
    raise NotImplementedError, 'No "apply!" method was implemented by this Atom.'
  end

end