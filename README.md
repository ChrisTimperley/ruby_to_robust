ruby_to_robust
==============

RubyToRobust allows you to implement soft semantics in your programs so that they
may automatically recover from a range of supported exceptions in some sensible manner,
allowing the program to continue running.

The soft semantics provided by this project were originally designed to be exploited by
Wallace.rb to provide robustness and support for soft grammars when using Grammatical Evolution.

Two different soft semantics solutions are provided by RubyToRobust, both based on the
Local and Global robustness schemes outlined in Chris Timperley's Masters Thesis.

* **Global:** The Global robustness module implements soft semantics by intercepting
  all exceptions thrown by a monitored method and using line information and other information
  provided by the exception to determine the root of the problem in the method source code
  which it then proceeds to "repair".
* **Local:** Rather than manipulating the source code of the monitored function, the Local
  robustness measure operates by implementing a series of monkey patches which ensure that
  a set of supported exceptions are never (or rarely) thrown within the context of the monitored
  function.

Please note that the definition of a "repaired method" used by this project is a method which
no longer produces errors (which would otherwise crash the program). This does not mean that the
program does what its programmer wanted (although sometimes it might).

The implementation and behaviour of this robustness scheme is very different to the implementation
used in Chris Timperley's Master Thesis.
* In the original version Global robustness was either enabled or disabled, and was constantly active
  except in certain classes and modules. The new implementation allows Global robustness to be constrained
  to a given block or method, so that the program may operate as it otherwise would outside the "protected"
  block.
* Exceptions are treated as soon as they are thrown outside the context of the monitored method.
  The original Global robustness would allow exceptions to propagate through the program (allowing
  them to be caught by a parent context) up till the point they would crash Ruby.
* Performance is hugely improved! By providing the optional file name and line number parameters to
  dynamically evaluated procedures there is no need to use external files to extract detailed error information.
  Additionally, since the soft semantics are constrained to a given block or method, very few method calls
  have to be wrapped (and therefore slowed down).