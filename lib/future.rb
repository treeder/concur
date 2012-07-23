#An Future is a class that captures the results of a threaded object so you can retrieve the results later.
#This is what is returned from Executors.
#
# This particular Future can be used for synchronous blocks / runnables / callables that are run in a separate thread.

module Concur

  module Future
    def future?
      true
    end
  end

  class StandardFuture
    include Future

    attr_accessor :thread, :ex

    def initialize(runnable=nil, channel=nil, &block)

      @mutex = Mutex.new
      @cv = ConditionVariable.new
      @callable = runnable
      @channel = channel
      if block_given?
        @callable = block
      end

    end

    def run
      #Concur.logger.debug 'running StandardFuture'
      begin
        @result = @callable.call(@channel)
        Concur.logger.debug 'callable result: ' + @result.inspect
      rescue Exception => ex
        Concur.logger.debug "Error occurred! #{ex.class.name}: #{ex.message}"
        @ex = ex
      end
      @mutex.synchronize do # do we even need to synchronize? run should only ever be called once
        @complete = true
      end
      @cv.broadcast

    end

    def call
      run
    end

    def complete?
      @complete
    end

    # Returns results. Will wait for thread to complete execution if not already complete.
    def get
#      @thread.value
      unless @complete
        @mutex.synchronize do
          unless @complete
            @cv.wait(@mutex)
          end
        end
      end
      if @ex
        raise @ex
      end
      @result
    end
  end


end
