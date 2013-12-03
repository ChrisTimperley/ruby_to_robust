# The Local robustness module is a slightly tailored version of the local robustness layer
# proposed in Chris Timperley's Master's Thesis.
#
# For now patches are enabled and disabled by checking the status of the "enabled" flag in 
# the Local robustness module for each individual patch.
# 
# A far nicer alternative would be to implement patches as instances of a Patch class.
# This class would then contain details of the target class and method as well as a
# lambda function implementing the patched form of the method.
#
# WARNING: Thread safety is a concern.
#
# Author: Chris Timperley
module RubyToRobust::Local

  # By default the robustness measures are disabled.
  @enabled = false

  # List of associated contexts for soft-binding.
  @contexts = []

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
    # to use "softer" semantics.
    begin

      enable_patches!
      return method.call(*params)

    # Ensure that all the patches are disabled and the original semantics
    # are restored before returning the result, even when an exception
    # might occur.
    ensure
      disable_patches!
    end

  end

  # Returns true if this robustness measure is enabled, false if not.
  def self.enabled?
    @enabled
  end

  # Returns false if local robustness is disabled.
  def self.disabled?
    not enabled?
  end

  # Prepares the local robustness layer to be used.
  # Produces the method look-up table for the associated context object and
  # detaches all the original methods.
  #
  # *Parameters:*
  # * context, the context object to prepare.
  def self.prepare(context)
    @contexts << context
    context.collapse_methods!
  end

  # Clears the method look-up table for each associated context object and
  # clears the list of associated context objects.
  def self.clear
    @contexts.each { |c| c.restore_methods! }
    @contexts.clear
  end

  protected
  
  # Patch
  # - class (e.g. Float)
  # - method (e.g. :/)
  # - patch (lambda)
  # - apply()
  # - unapply()
  def self.register_patch

  end

  # Enables all the local robustness patches for soft semantics.
  def self.enable_patches!
    @enabled = true
  end

  # Disables the soft semantic patches and restores standard semantics.
  def self.disable_patches!
    @enabled = false
  end

end