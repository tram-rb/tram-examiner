Gem::Specification.new do |gem|
  gem.name     = "tram-examiner"
  gem.version  = "0.0.2"
  gem.author   = "Andrew Kozin (nepalez)"
  gem.email    = "andrew.kozin@gmail.com"
  gem.homepage = "https://github.com/nepalez/tram-examiner"
  gem.summary  = "Standalone validator for Rails objects"
  gem.license  = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = Dir["README.md", "LICENSE", "CHANGELOG.md"]

  gem.required_ruby_version = ">= 2.3"

  gem.add_runtime_dependency "dry-memoizer", "~> 0.0.1"
  gem.add_runtime_dependency "activemodel",  "~> 5.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rubocop"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-byebug"
end
