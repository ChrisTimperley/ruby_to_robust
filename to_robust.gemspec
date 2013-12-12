require 'rake'

Gem::Specification.new do |s|

  s.name        = 'to_robust'
  s.version     = '1.0.0.pre'
  s.date        = '2013-12-12'
  s.summary     = "Adds optional soft semantics and self-repair to methods."
  s.description = "Soft semantics for Ruby to automatically recover from fatal exceptions and to repair damaged programs.
  Used to improve robustness, expressiveness and performance in Grammatical Evolution."
  s.author      = 'Chris Timperley'
  s.email       = 'christimperley@gmail.com'
  s.homepage    = 'https://github.com/ChrisTimperley/ruby_to_robust'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.8.6'

  s.files       = FileList['lib/*', 'test/*'].to_a
  
  s.add_run_time_dependency "levenshtein", ["~> 0.2.2"]

end