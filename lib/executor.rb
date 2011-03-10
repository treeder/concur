require_relative 'runnable'
require_relative 'future'
require_relative 'thread_pool'


module Concur


  # Decouples task submission from how each task is run. An Executor can be backed by a thread pool or some
  # other mechanism, but how you use the Executor won't change. This allows you to change the backend implementation
  # with minor code changes.
  #
  # Inspired by java.util.concurrent.Executor
  class Executor

    attr_accessor :thread_pool

    def initialize(options={})

    end

    def self.new_thread_pool_executor(options={})
      executor = Executor.new
      executor.thread_pool = ThreadPool.new(options[:max_size])
      p executor.thread_pool
      executor
    end

    def execute(runnable, &blk)
      puts 'executing ' + runnable.inspect
      f = Future.new(runnable, &blk)
      if @thread_pool
        @thread_pool.process(f)
      else
        @thread = Thread.new do
          f.thread = @thread
          f.call
        end
      end
      f
    end

    def shutdown
       if @thread_pool
         @thread_pool.shutdown
       end
    end
  end
end
