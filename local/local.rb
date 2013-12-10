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

  # List of patches.
  @patches = []

  # Executes a given block under local robustness protection.
  #
  # *Parameters:*
  # * *contexts, depickled list of context objects to protect method calls for.
  # * &block, the block to execute under local robustness protection.
  #
  # *Returns:*
  # * The result of the block execution.
  def self.protected(*contexts, &block)
    patches.each { |p| p.prepare!(contexts) }
    patches.each { |p| p.enable! }
    
    begin
      result = block.call
    ensure
      patches.each { |p| p.disable! }
    end

    return result
  end

end