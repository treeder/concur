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

## Futures

A Future is what is returned from the execute method. Call `future.get` to get the results of the block
or the Callable object. If it's not finished, `get` will block until it is. `get` will also raise an Exception
if an Exception occurred during running.

