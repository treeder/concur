require_relative 'runnable'
require_relative 'future'

module Concur

  # Decouples task submission from how each task is run. An Executor can be backed by a thread pool or some
  # other mechanism, but how you use the Executor won't change. This allows you to change the backend implementation
  # with minor code changes.
  #
  # Inspired by java.util.concurrent.Executor
  module Executor

    class Base
      def initialize(options={})

      end


      def shutdown

      end

      def execute
        raise "execute() not implemented, this is an invalid implemention."
      end

      def queue_size
        0
      end
    end


    def self.new_single_threaded_executor(options={})
      #executor = Executor.new
      executor = SingleThreaded.new
      executor
    end

    def self.new_multi_threaded_executor(options={})
      #executor = Executor.new
      executor = MultiThreaded.new
      executor
    end

    def self.new_thread_pool_executor(max_size, options={})
      #executor = Executor.new
      executor = ThreadPool.new(max_size)
      executor
    end
    #
    #def self.new_eventmachine_executor()
    #  require_relative 'executors/event_machine_executor'
    #  executor = EventMachineExecutor.new()
    #  executor
    #end
    #
    ## NOT WORKING
    #def self.new_neverblock_executor(max_size)
    #  require_relative 'executors/never_block_executor'
    #  executor = NeverBlockExecutor.new(max_size)
    #  executor
    #end


  end


  # todo: should maybe have these backends extend Executor and just override what's necessary
  class SingleThreaded < Executor::Base
    def process(f=nil, channel=nil, &blk)
      f = StandardFuture.new(f, channel, &blk)
      f.call
      f
    end

    def execute(f=nil, channel=nil, &blk)
         process(f, channel, &blk)
       end

    def shutdown
    end
  end

  # Spins off a new thread per job
  class MultiThreaded < Executor::Base
    def process(f=nil, channel=nil, &blk)
      f = StandardFuture.new(f, channel, &blk)
      @thread = Thread.new do
        f.call
      end
      f.thread = @thread
      f
    end

    def execute(f=nil, channel=nil, &blk)
      process(f, channel, &blk)
    end

    def shutdown

    end
  end
end
