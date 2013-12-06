# What if we give the Local robustness layer some module / context / binding that it uses
# to 

# In our current implementation of soft method binding, when a method is added to an object
# (or class), that method is instantly removed and stored in a private method look-up hash
# (indexed by the string form of the method name).
#
# All calls to that object which use a method defined after the loading of the soft method
# binding patch will automatically invoke the "method_missing" method regardless of whether
# the method would normally exist or not. The "method_missing" method is then exploited to
# perform custom routing of method calls, such that both method names and arguments can be
# soft.
#
# One problem with this approach is how the behaviour of method calls does not depend
# entirely on whether the robustness measure is enabled or disabled, but rather on when the
# robustness measure was enabled relative to the method call. If the patch is enabled part
# way through a program, the method's will have already been added, and so the "method_missing"
# method for custom routing will never be called when an exact method name (but incorrect
# arguments) are provided. Even when an incorrect method name is provided, the most appropriate
# method for matching will not be stored in the private method look-up hash.
#
# An alternative is to remove the methods of certain classes, modules or objects, and to compose
# them into the private method look-up hash upon the enabling of the local robustness layer. The
# method look-up hash could then be inverted into the original methods, restoring the original
# semantics.
#
# One issue with this is the potentially unnecessary overhead of creating and inverting the
# method look-up hash. If we are constantly using the same set of functions, then it doesn't pay
# for us to constantly invert and re-create the method look-up hash; instead we could keep the
# hash cached until we are finished using it.
#
# Local.load(:objects)
# Local.enable
# Local.disable
# Local.unload(:objects)
#