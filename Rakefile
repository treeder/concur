require './lib/concur.rb'

begin
    require 'jeweler2'
    Jeweler::Tasks.new do |gemspec|
        gemspec.name = "concur"
        gemspec.summary = "A concurrency library for Ruby inspired by java.util.concurrency and Go (golang). By http://www.appoxy.com"
        gemspec.email = "travis@appoxy.com"
        gemspec.homepage = "http://github.com/treeder/concur/"
        gemspec.description = "A concurrency library for Ruby inspired by java.util.concurrency and Go (golang). By http://www.appoxy.com"
        gemspec.authors = ["Travis Reeder"]
        gemspec.files = FileList['lib/**/*.rb']
        #gemspec.add_dependency 'faraday'
    end
    Jeweler::GemcutterTasks.new
rescue LoadError
    puts "Jeweler not available. Install it with: sudo gem install jeweler2"
end

