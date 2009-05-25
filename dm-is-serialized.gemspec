begin
  require "rubygems/specification"
rescue SecurityError
  # http://gems.github.com
end

VERSION  = "0.0.2"
SPECIFICATION = ::Gem::Specification.new do |s|
  s.name = "dm-is-serialized"
  s.version = VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/dm-is-serialized"
  s.summary = "This plugin helps you to serialize your records into very short strings for storing in cookies."
  # s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.add_dependency "dm-core"
  s.require_paths = ["lib"]
  # s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")
  # s.rubyforge_project = "rango"
end
