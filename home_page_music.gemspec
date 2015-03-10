$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "home_page_music/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "home_page_music"
  s.version     = HomePageMusic::VERSION
  s.authors     = ["Mathias Gawlista"]
  s.email       = ["gawlista.mathias@vimn.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of HomePageMusic."
  s.description = "TODO: Description of HomePageMusic."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "mysql2"
end
