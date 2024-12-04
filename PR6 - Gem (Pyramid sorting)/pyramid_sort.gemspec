# frozen_string_literal: true

require_relative "lib/pyramid_sort/version"

Gem::Specification.new do |spec|
  spec.name = "pyramid_sort"
  spec.version = PyramidSort::VERSION
  spec.authors = ["Vidziano"]
  spec.email = ["bviktora2013@gmail.com"]

  spec.summary = "A Ruby gem implementing heap sort (pyramid sort) algorithm."
  spec.description = "This gem provides an efficient implementation of the heap sort algorithm, also known as pyramid sort, for sorting arrays in Ruby."
  spec.homepage = "https://github.com/Vidziano/Programming-technology-stack/tree/87a5453245775267d74d7bdc2aafa9a82812a95c/PR6%20-%20Gem%20(Pyramid%20sorting)" # Заміна TODO на реальний URL
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org" # Вказати сервер для публікації гема
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Vidziano/Programming-technology-stack/tree/87a5453245775267d74d7bdc2aafa9a82812a95c/PR6%20-%20Gem%20(Pyramid%20sorting)" # Посилання на публічний репозиторій
  spec.metadata["changelog_uri"] = "https://github.com/vidziano/pyramid_sort/CHANGELOG.md" # Посилання на CHANGELOG

  # Specify which files should be added to the gem when it is released.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
