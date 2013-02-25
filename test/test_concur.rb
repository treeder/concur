gem 'test-unit'
require 'test/unit'
require 'rest'
require_relative '../lib/concur'
require_relative 'job'


class TestConcur < Test::Unit::TestCase
  @@durations = []

  def test_speed_comparison
    times = 10

    # todo: use quicky gem

    executor = Concur::Executor.new_single_threaded_executor
    non_concurrent_duration = run_gets("non concurrent", executor)
    executor.shutdown

    executor = Concur::Executor.new_multi_threaded_executor
    concurrent_duration = run_gets("multi thread", executor)
    assert concurrent_duration < (non_concurrent_duration/2)
    executor.shutdown

    executor = Concur::Executor.new_thread_pool_executor(4)
    pooled_duration = run_gets("thread pool", executor)
    assert pooled_duration < (non_concurrent_duration/2)
    executor.shutdown
    #
    #executor = Concur::Executor.new_eventmachine_executor()
    #em_duration = run_gets("eventmachine", executor)
    #assert em_duration < (non_concurrent_duration/2)
    #executor.shutdown

    puts "----"
    @@durations.each do |s|
      puts s
    end

  end

  def run_gets(name, executor)
    puts "Running #{name}..."
    start_time = Time.now
    rest = Rest::Client.new

    futures = []
    10.times do |i|
      url = "http://rest-test.iron.io/code/200"
      futures << executor.execute() do
        response = rest.get(url)
      end
    end
    futures.each do |f|
      puts 'f=' + f.inspect
#      puts 'got=' + f.get.inspect
      assert f.get.code >= 200 && f.get.code < 400
    end
    concurrent_duration = Time.now - start_time
    o = "#{name} duration=" + concurrent_duration.to_s
    puts o
    @@durations << o
    concurrent_duration
  end

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


end



