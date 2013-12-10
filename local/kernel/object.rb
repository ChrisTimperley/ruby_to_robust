class Object

  # Hides all public instance methods specific to this class by prepending their names
  # with "__" and making them private.
  def hide_methods!
    public_instance_methods(false).each do |original|

      # Ignore method missing.
      next if original == :method_missing

      # Prepend "__" to the method name and make it private.
      hidden = ('__' + sym.to_s).to_sym
      alias_method :hidden :original
      private :hidden

    end
  end

  # Unhides all previously hidden methods, restoring the object/class/module to its
  # original state.
  def unhide_methods!
    hidden_method_symbols.each do |sym|
      original = sym.to_s[2..-1].to_sym
      alias_method :original :sym
      remove_method :sym
      public :original
    end
  end

  # Returns a hash of the hidden methods of this object (indexed by the original name
  # of the methods, as strings).
  def hidden_methods
    Hash[hidden_method_symbols.map { |sym| [sym.to_s[2..-1], method(sym)] }]
  end

  private

  # Returns an array of the symbols for each of the hidden methods (including their "__").
  def hidden_method_symbols
    private_instance_methods(false).select { |m| m.start_with? '__' }
  end

end