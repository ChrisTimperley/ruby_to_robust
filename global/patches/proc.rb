# How do we perform garbage collection on dynamically generated static methods?
class Proc

  # The source code for this procedure, only used by eval'd procs.
  @source = nil

  # Produces the source code for this procedure.
  def to_source
    @source
  end

  # Converts this procedure into a static method (so that full error debugging
  # may be performed).
  #
  # Hopefully, this is totally redundant!
  def to_static

    # Determine a name for this proc.

    # Create a static definition for this procedure, write it to a temporary file
    # and then load that file.
    static_definition = # create a static definition!
    t_file = Tempfile.new([static_definition, '.rb'])
    begin

      # It is important that we use load rather than require here since a
      # temporary file may be created at a given path more than once
      # during the program.
      load t_file.path

    # We ensure that the temporary file is instantly discarded to prevent
    # large amounts of temporary files consuming memory and disk space.
    ensure
      t_file.close
      t_file.unlink
    end

  end

end