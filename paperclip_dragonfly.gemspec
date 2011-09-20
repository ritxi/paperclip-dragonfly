# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
$:.push File.expand_path("../lib", __FILE__)
require "paperclip_dragonfly/version"

Gem::Specification.new do |s|
  s.name = "paperclip_dragonfly"
  s.description = "Insert Paperclip-dragonfly description."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = PaperclipDragonfly::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ricard Forniol"]
  s.email       = ["ricard@forniol.cat"]
  s.summary     = %q{Move easily from paperclip to dragonfly}
  s.description = %q{Dragonfly uses current datetime to store files, instead use :id_partition like paperclip and add model scope to separte diferent model images}


  s.add_dependency('dragonfly')
  s.add_dependency('rails', '3.0.10')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end