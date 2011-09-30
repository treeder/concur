require 'thread'
begin
  require 'fastthread'
rescue LoadError
  # $stderr.puts "Using the ruby-core thread implementation"
end

module Concur

  # Another example is here: # from: http://stackoverflow.com/questions/81788/deadlock-in-threadpool
  class ThreadPool
    def initialize(max_size)
      @max_size = max_size
#      @thread_queue = SizedQueue.new(max_size)
      @running = true
      @mutex = Mutex.new
      @cv = ConditionVariable.new
      @queue = Queue.new
      @threads = []

    end

    def shutdown
      @running = false
    end

    def process(callable, &blk)
      callable = blk if block_given?
      @queue.push(callable)
      start_thread
    end

    def start_thread
      @mutex.synchronize do
        if !@queue.empty? && @threads.size <= @max_size
          t = UberThread.new do
            while @running
              f = @queue.pop
              f.thread = t
              f.call
            end
#            Concur.logger.info "Thread dying " + t.inspect
          end
          Concur.logger.debug "Created new thread " + t.inspect
          @threads << t
        end
      end
    end

    class UberThread < Thread

      def initialize
        super
      end

    end

  end



end
