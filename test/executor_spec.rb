require 'rspec'

require_relative '../lib/concur'
require_relative 'job'

describe Concur::Executor do
  describe "#score" do
    it "runs faster in parallel" do
      times = 10

      job = Job.new(1)
      puts 'runnable? ' + job.is_a?(Concur::Runnable).to_s
      start_time = Time.now
      times.times do |i|
        job = Job.new(i)
        job.run
      end
      non_concurrent_duration = Time.now - start_time
      puts "duration=" + non_concurrent_duration.to_s

      puts '---------------'

      puts "Now for concurrent"
      executor = Concur::Executor.new_multi_threaded_executor
      start_time = Time.now

      jobs = []
      times.times do |i|
        job = Job.new(i)
        jobs << executor.execute(job)
      end
      jobs.each do |j|
        puts "uber fast result=#{j.get}"
      end
      concurrent_duration = Time.now - start_time
      puts "duration=" + concurrent_duration.to_s

      concurrent_duration.should be < (non_concurrent_duration/2)

      puts "Now for pooled"
      executor = Concur::Executor.new_thread_pool_executor(10)
      start_time = Time.now

      jobs = []
      times.times do |i|
        job = Job.new(i)
        future = executor.execute(job)
        jobs << future
      end
      jobs.each do |j|
        puts "uber fast result=#{j.get}"
      end
      pooled_duration = Time.now - start_time
      puts "pooled_duration=" + pooled_duration.to_s

      pooled_duration.should be < (non_concurrent_duration/2)
#      pooled_duration.should_be > concurrent_duration

      executor.shutdown

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


