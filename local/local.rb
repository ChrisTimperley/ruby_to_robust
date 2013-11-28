# The Local robustness module is a slightly tailored version of the local robustness layer
# proposed in Chris Timperley's Master's Thesis.
#
# Author: Chris Timperley
module RubyToRubust::Local

  # Executes a given method (or proc) under local robustness protection.
  #
  # *Parameters:*
  # * method, the method to execute using local robustness protection.
  # * params, the parameters to the method call.
  #
  # *Returns:*
  # The result of the method call.
  def self.execute(method, params)

    # Before calling the method, enable all the attached monkey patches
    # to use "softer" semantics. After finding the result of the 
    begin

      enable_patches!
      result = method.call(*params)

    # Ensure that all the patches are disabled and the original semantics
    # are restored before returning the result, even when an exception
    # might occur.
    ensure
      disable_patches!
    end

    return result

  end


  protected

  def self.enable_patches!

  end

  def self.disable_patches!

  end

end