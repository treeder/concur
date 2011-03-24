require_relative '../lib/runnable'
require 'rest-client'
require 'eventmachine'

class Job
  include Concur::Runnable

  def initialize(i, options={})
    @i = i
    if options[:em]
      @em = true
    end
  end

  def em_request(url)
    puts 'emrequest for ' + url
    http = EventMachine::Protocols::HttpClient.request(
        :host => url,
        :port => 80,
        :request => "/"
    )
    http.callback { |response|
      puts response[:status]
      puts response[:headers]
      puts response[:content]
    }
  end

  def run
    puts "Starting #{@i}... em? #{@em}"
#    sleep 1
    urls = ["www.yahoo.com", "www.microsoft.com"] # , "www.github.com"
    if @em
      urls.each do |u|
        em_request(u)
      end
    else
      urls.each do |u|
        get(u)
      end
    end
    puts "Finished #{@i}"
    "response #{@i}"
  end

  def get(url)
    puts 'getting ' + url
    RestClient.get "http://#{url}"
  end

end