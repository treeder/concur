# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "concur"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Travis Reeder"]
  s.date = "2012-07-26"
  s.description = "A concurrency library for Ruby inspired by java.util.concurrency. By http://www.appoxy.com"
  s.email = "treeder@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.markdown",
    "README.md"
  ]
  s.files = [
    "lib/completer.rb",
    "lib/concur.rb",
    "lib/concur/config.rb",
    "lib/concur/go.rb",
    "lib/executor.rb",
    "lib/executors/event_machine_executor.rb",
    "lib/executors/never_block_executor.rb",
    "lib/future.rb",
    "lib/futures/event_machine_future.rb",
    "lib/runnable.rb",
    "lib/thread_pool.rb"
  ]
  s.homepage = "http://github.com/treeder/concur/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A concurrency library for Ruby inspired by java.util.concurrency. By http://www.appoxy.com"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, [">= 0"])
      s.add_runtime_dependency(%q<faraday>, [">= 0"])
    else
      s.add_dependency(%q<faraday>, [">= 0"])
      s.add_dependency(%q<faraday>, [">= 0"])
    end
  else
    s.add_dependency(%q<faraday>, [">= 0"])
    s.add_dependency(%q<faraday>, [">= 0"])
  end
end

