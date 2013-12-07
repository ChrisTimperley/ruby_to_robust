# Handles zero division errors.
class RubyToRobust::Global::Strategies::DivideByZeroStrategy < RubyToRobust::Global::Strategy

  # Wraps all inline division operators in a safety barrier, preventing them from raising
  # a ZeroDivisionError and instead causing them to return zero when zero is used as the
  # denominator.
  #
  # *Parameters:*
  # * line, the line to wrap the inline division operators for.
  #
  # *Returns:*
  # The provided line with all inline division operators wrapped.
  def self.wrap_ops(line)

    # Find the index of each division operator in the string.
    last_index = -1
    operations = []
    until last_index.nil?
      last_index = line.index('/', last_index+1)
      operations << last_index unless last_index.nil?
    end
    
    # Find the start index of the left argument and the end index of
    # the right argument.
    operations.map! do |location|
    
      # Find the index of the start of the left argument.
      start_at = index = location
      started = finished = false
      bracket_depth = 0
      until finished or start_at == 0
        
        # Move to the next character.
        index -= 1
        char = line[index]
        
        # Increase the bracket depth if a bracket is closed.
        if char == ")"
          started = true
          bracket_depth += 1
        
        # Decrease the bracket depth if a bracket is opened.
        # If the resulting bracket depth is zero or less then
        # the argument is finished.
        elsif char == "("
          started = true
          bracket_depth -= 1
          finished = bracket_depth <= 0
          end_at = index if bracket_depth == 0
          
        # Spaces are only accepted if they are enclosed within brackets
        # or they trail the argument.
        elsif char == " "
          finished = (bracket_depth == 0 and started)
          
        # Letters, digits and dots are accepted without question.
        # Ensure that the argument is marked as "started" when they
        # are encountered.
        elsif char.match(/^[[:alnum:]]$/) or char == "."
          started = true
        
        # All other characters are only accepted if they are
        # enclosed within brackets.
        else
          started = true
          finished = true if bracket_depth <= 0
        end
        
        # Move back the starting point unless it has been found.
        start_at = index unless finished
      
      end
      
      # Find the index of the end of the right argument.
      index = end_at = location
      started = finished = false
      bracket_depth = 0
      until finished or end_at == line.length-1
      
        # Look at the character at the next index.
        index += 1
        char = line[index]
        
        # Increase the bracket depth if a bracket is opened.
        if char == "("
          started = true
          bracket_depth += 1
        
        # Decrease the bracket depth if a bracket is closed.
        # If the bracket closed is the last bracket left,
        # then this marks the end of the argument.
        elsif char == ")"
          started = true
          bracket_depth -= 1
          finished = bracket_depth <= 0
          end_at = index if bracket_depth == 0
        
        # Spaces are only accepted if they are enclosed within brackets
        # or they lead the argument.
        elsif char == " "
          finished = (bracket_depth == 0 and started)
        
        # Letters, digits and dots are accepted without question.
        # Ensure that the argument is marked as "started" when they
        # are encountered.
        elsif char.match(/^[[:alnum:]]$/) or char == "."
          started = true
        
        # All other characters are only accepted if they are
        # enclosed within brackets.
        else
          started = true
          finished = true if bracket_depth <= 0
        end
        
        # Move back the end point unless it has been found.
        end_at = index unless finished
        
      end
      
      # Convert the index of the division operator to the start and
      # end indices of the operation.
      [start_at, end_at]
      
    end
    
    # Merge any overlapping operations into a single wrapper.
    temp = []
    operations.each do |x_start, x_end|
      merged = false
      temp.each_index do |y|
        y_start, y_end = temp[y]
        if x_start == y_end
          temp[y][1] = x_end
          merged = true
        elsif x_end == y_start
          temp[y][0] = x_start
          merged = true
        end
        break if merged
      end
      temp << [x_start, x_end] unless merged
    end
    operations = temp
    
    # Wrap each of the operations in the original string.
    operations.each_index do |x|
    
      # Retrieve the co-ordinates of the operation.
      start_at, end_at = operations[x]
    
      # Wrap the operation
      line.insert start_at, "(RubyToRobust::Global.prevent_dbz{"
      line.insert end_at+20, "})"
      
      # Modify the coordinates of all other method calls.
      (x...operations.length).each do |y|
      
        # If this operation ends before another begins, shift
        # both the start and end of that operation.
        if end_at < operations[y][0]
          operations[y][0] += 21
          operations[y][1] += 21
        
        # If this X starts after Y but finishes before, then shift
        # the end of Y.
        elsif start_at > operations[y][0] and end_at < operations[y][1]
          operations[y][1] += 21
        
        # If this Y is within X, shift the start and end of Y by the
        # size of the prevention call opening.
        elsif start_at < operations[y][0] and end_at > operations[y][1]
          operations[y][0] += 19
          operations[y][1] += 19
        end
        
      end
      
    end
    
    # Return the transformed line.
    return line

  end

end