require 'rspec'
require 'neverblock'

require_relative '../lib/concur'
require_relative 'job'

@@durations = []

def run_jobs(name, executor, times, options={})
  puts "Running #{name}..."
  start_time = Time.now

  jobs = []
  times.times do |i|
    job = Job.new(i, options)
    jobs << executor.execute(job)
  end
  jobs.each do |j|
    puts "result=#{j.get}"
  end
  concurrent_duration = Time.now - start_time
o = "#{name} duration=" + concurrent_duration.to_s
  puts o
  @@durations << o
  concurrent_duration
end

describe Concur::Executor do
  describe "#score" do
    it "runs faster in parallel" do
      times = 10

      job = Job.new(1)
      puts 'runnable? ' + job.is_a?(Concur::Runnable).to_s
      non_concurrent_duration = 0
#
      executor = Concur::Executor.new_single_threaded_executor
      non_concurrent_duration =run_jobs("non concurrent", executor, times)
      executor.shutdown

      executor = Concur::Executor.new_multi_threaded_executor
      concurrent_duration = run_jobs("multi thread", executor, times)
      concurrent_duration.should be < (non_concurrent_duration/2)
      executor.shutdown

      executor = Concur::Executor.new_thread_pool_executor(10)
      pooled_duration = run_jobs("thread pool", executor, times)
      pooled_duration.should be < (non_concurrent_duration/2)
      executor.shutdown

      # Don't think I know how to use NeverBlock properly
#      executor = Concur::Executor.new_neverblock_executor(10)
#      neverblock_duration = run_jobs("never blocked", executor, times)
#      neverblock_duration.should be < (non_concurrent_duration/2)
#      executor.shutdown

      executor = Concur::Executor.new_eventmachine_executor()
      em_duration = run_jobs("eventmachine", executor, times, :em=>true)
      em_duration.should be < (non_concurrent_duration/2)
      executor.shutdown

      @@durations.each do |s|
        puts s
      end

    end
  end
end

describe Concur::Future do

  describe "#new" do

    it "can accept blocks" do
      future = Concur::Future.new do
        puts "i'm in the block"
        "result of block"
      end
      puts 'get=' + future.get
      future.get.should == "result of block"
    end

  end

end


