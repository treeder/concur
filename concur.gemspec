# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{concur}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Travis Reeder"]
  s.date = %q{2011-04-19}
  s.description = %q{A concurrency library for Ruby inspired by java.util.concurrency. By http://www.appoxy.com}
  s.email = %q{travis@appoxy.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "lib/concur.rb",
    "lib/executor.rb",
    "lib/executors/event_machine_executor.rb",
    "lib/executors/never_block_executor.rb",
    "lib/future.rb",
    "lib/futures/event_machine_future.rb",
    "lib/runnable.rb",
    "lib/thread_pool.rb"
  ]
  s.homepage = %q{http://github.com/appoxy/concur/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{A concurrency library for Ruby inspired by java.util.concurrency. By http://www.appoxy.com}
  s.test_files = [
    "test/executor_spec.rb",
    "test/job.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

