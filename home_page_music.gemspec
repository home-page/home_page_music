$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'home_page_music/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'home_page_music'
  s.version     = HomePageMusic::VERSION
  s.authors     = ['Mathias Gawlista']
  s.email       = ['gawlista@gmail.com']
  s.homepage    = 'http://Blog.Home-Page.Software'
  s.summary     = 'Music module for home_page gem.'
  s.description = 'Music plugin for #Rails CMS http://Home-Page.Software - changes: http://bit.ly/home-page-music-0-0-2'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'home_page', '~> 0.0.6'

  s.add_dependency 'lastfm', '~> 1.26.0'

  s.add_development_dependency 'mysql2'
end
