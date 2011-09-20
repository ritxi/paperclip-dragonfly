# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "paperclip_dragonfly"
  s.summary = "Insert Paperclip-dragonfly summary."
  s.description = "Insert Paperclip-dragonfly description."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
end