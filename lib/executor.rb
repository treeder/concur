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

    def self.new_single_threaded_executor(options={})
      executor = Executor.new
      executor.thread_pool = SingleThreaded.new
      executor
    end

    def self.new_multi_threaded_executor(options={})
      executor = Executor.new
      executor.thread_pool = MultiThreaded.new
      executor
    end

    def self.new_thread_pool_executor(max_size, options={})
      executor = Executor.new
      executor.thread_pool = ThreadPool.new(max_size)
      executor
    end

    def self.new_eventmachine_executor()
      require_relative 'executors/event_machine_executor'
      executor = EventMachineExecutor.new()
      executor
    end

    # NOT WORKING
    def self.new_neverblock_executor(max_size)
      require_relative 'executors/never_block_executor'
      executor = NeverBlockExecutor.new(max_size)
      executor
    end

    def execute(runnable=nil, &blk)
      f = StandardFuture.new(runnable, &blk)
      @thread_pool.process(f)
      f
    end

    def shutdown
      @thread_pool.shutdown
    end
  end

  # todo: should maybe have these backends extend Executor and just override what's necessary
  class SingleThreaded
    def process(f)
      f.call
    end

    def shutdown
    end
  end

  class MultiThreaded
    def process(f)
      @thread = Thread.new do
        f.thread = @thread
        f.call
      end
    end

    def shutdown

    end
  end
end
