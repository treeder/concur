# Concur - A concurrency library for Ruby inspired by java.util.concurrency

## General Usage

    # Choose which executor you want, there are several to choose from
    executor = Concur::Executor.new_thread_pool_executor(10)
    start_time = Time.now

    jobs = []
    times.times do |i|
      future = executor.execute do
        puts "hello #{i}"
        "result #{i}"
      end
      jobs << future
    end
    jobs.each do |j|
      puts "uber fast result=#{j.get}"
    end
    pooled_duration = Time.now - start_time
    puts "pooled_duration=" + pooled_duration.to_s
    executor.shutdown

## EventMachine / Non-blocking I/O

Perhaps more important/interesting these days is EventMachine/non-blocking io. When your program is io bound you can
get similar performance (if not better) on a single thread as you can with multi-threads.

    # Create an EventMachineExecutor
    executor = Concur::Executor.new_eventmachine_executor()

    # Now fire off a bunch of http requests
    futures = []
    TestConcur.urls.each do |url|
      params_to_send = {}
      params_to_send[:base_url] = url
      params_to_send[:path] = "/"
      params_to_send[:http_method] = :get
      futures << executor.http_request(params_to_send)
    end
    futures.each do |f|
      puts 'got=' + f.get.inspect
      assert f.get.status >= 200 && f.get.status < 400
    end


See https://github.com/appoxy/concur/blob/master/test/test_concur.rb for more examples.

## Futures

A Future is what is returned from the execute method. Call `future.get` to get the results of the block
or the Callable object. If it's not finished, `get` will block until it is. `get` will also raise an Exception
if an Exception occurred during running.

