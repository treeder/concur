module Concur

  #An Future is a class that captures the results of a threaded object so you can retreive the results later.
  #This is what is returned from Executors.
  class Future
    attr_accessor :thread, :pool

    def initialize(runnable=nil, &block)

#      if block
#        @thread = Thread.new do
#          @result = yield
#        end
#      else
#        @thread = Thread.new do
#          @result = runnable.run
#        end
#      end

      @mutex = Mutex.new
      @cv = ConditionVariable.new
      @callable = runnable
      if block_given?
        @callable = block
      end

    end

    def run
      @result = @callable.call
      @complete = true
      @cv.signal
    end

    def call
      run
    end

    # Returns results. Will wait for thread to complete execution if not already complete.
    def get
#      @thread.value
      @mutex.synchronize do
        unless @complete
          @cv.wait(@mutex)
        end
      end
      @result
    end
  end
end
