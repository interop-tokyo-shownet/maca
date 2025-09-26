# frozen_string_literal: true

require_relative "lib/maca/version"

Gem::Specification.new do |spec|
  spec.name = "maca"
  spec.version = Maca::VERSION
  spec.authors = ["Taketo Takashima"]
  spec.email = ["t.taketo1113@gmail.com"]

  spec.summary = "A class to manipulate a MAC Address in ruby"
  spec.description = "maca provides a set of methods to manipulate a MAC Address."
  spec.homepage = "https://github.com/interop-tokyo-shownet/maca"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/interop-tokyo-shownet/maca"
  spec.metadata["changelog_uri"] = "https://github.com/interop-tokyo-shownet/maca/releases"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
