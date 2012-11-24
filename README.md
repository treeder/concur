# Concur - A concurrency library for Ruby inspired by java.util.concurrency and Go (golang).

## Getting Started

Install gem:

```
gem install concur
```

## NEW Go Style Usage

### Basic

```ruby
require 'concur'

# set max threads (optional)
Concur.config.max_threads = 10

# fire off blocks using go
100.times do |i|
  go do
    puts "hello #{i}"
    sleep 1
    puts "#{i} awoke"
    puts "hi there"
  end
  puts "done #{i}"
end
```

### Use channels to communicate

```ruby
require 'concur'

# Use channels to communicate
ch = Concur::Channel.new
20.times do |i|
  go do
    puts "hello channel #{i} #{ch}"
    sleep 2
    # push to channel
    ch << "pushed #{i} to channel"
  end
end

# Read from channel
ch.each do |x|
  puts "Got #{x} from channel"
end
```

### Catching exceptions and checking for different return types on the channel

```ruby
require 'concur'

# Use channels to communicate
ch = Concur::Channel.new
20.times do |i|
  go do
    begin
      puts "hello channel #{i}"
      ch << "pushed #{i} to channel"
    rescue => ex
      ch << ex
    end
  end
end

# Read from channel
ch.each do |m|
  puts "Got #{m} from channel"
  case m
    when String
      puts m
    when Exception
      puts "ERROR!!! #{m}"
    else
      puts "Something else: #{m}"
  end
end
```


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

DEPRECATED!!

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

