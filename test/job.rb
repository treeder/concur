require_relative '../lib/runnable'

class Job
  include Concur::Runnable

  def initialize(i)
    @i = i
  end

  def run
    sleep 0.25
    puts "Finished #{@i}"
    "response #{@i}"
  end

end