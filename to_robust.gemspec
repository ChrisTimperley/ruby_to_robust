require 'rake'

Gem::Specification.new do |s|

  s.name        = 'to_robust'
  s.version     = '1.0.1'
  s.date        = '2014-08-10'
  s.summary     = "Adds optional soft semantics and self-repair to methods."
  s.description = <<-EOF
    Soft semantics for Ruby to automatically recover from fatal exceptions and to repair damaged programs.
    Used to improve robustness, expressiveness and performance in Grammatical Evolution.
  EOF
  s.author      = 'Chris Timperley'
  s.email       = 'christimperley@gmail.com'
  s.homepage    = 'https://github.com/ChrisTimperley/ruby_to_robust'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.8.6'

  s.files       = FileList[
    'LICENSE',
    'README.md',

    'lib/to_robust.rb',

    'lib/global/*',
    'lib/global/fix/*',
    'lib/global/kernel/*',
    'lib/global/strategies/*',

    'lib/local/*',
    'lib/local/kernel/*',
    'lib/local/strategies/*',

    'test/local/*',
    'test/global/*'
  ].to_a
  s.test_files = FileList['test/local/*', 'test/global/*'].to_a

  #s.add_runtime_dependency "levenshtein", ["~> 0.2.2"]

end