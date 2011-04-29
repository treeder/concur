# This future enables a blocking get for a result from EventMachine HTTP request.

module Concur

  class EventMachineError < StandardError

    def initialize(callbackable)
      super("Error in #{callbackable.class.name}")
      @callbackable = callbackable

    end
  end

  class EventMachineFutureCallback

    def future?
      true
    end

    attr_accessor :errblk, :callblk

    def initialize(callbackable, &block)
      puts 'EventMachineFutureCallback.initialize: ' + callbackable.inspect
      @callbackable = callbackable
      if block_given?
        @callback = block
      end
    end

    def run

#      http = @callbackable
#      http.errback {
#        @ex = EventMachineError.new(http)
#        complete
#      }
#      http.callback {
#        if @callback
#          @callback.call(@callbackable)
#        end
#        complete
#      }


    end
    def errback &blk
        @errblk = blk
      end

      def callback &blk
        @callback = blk
      end

    def errback2 &blk
      puts 'EventMachineFutureCallback.errback'
      proc = Proc.new do
        puts 'errback proc'
        blk.call(@callbackable)
      end
      puts 'setting errback on ' + @callbackable.inspect
      @callbackable.errback &proc
      puts 'errback set'
    end

    def callback2 &blk
      puts 'EventMachineFutureCallback.callback'
      proc = Proc.new do
        puts 'callback proc @callback=' + @callback.inspect
        blk.call(@callbackable)
        if @callback
          @callback.call(@callbackable)
        end
      end
      @callbackable.callback &proc
    end
#
#    def call_callback(response)
#      puts 'call_callback=' + response.inspect
#      return unless callblk
#      callblk.call(response)
#    end
#
#    def call_errback(response)
#      return unless errblk
#      errblk.call(response)
#    end
  end

  class EventMachineFuture
    include Concur::Future

    attr_accessor :ex

    def initialize(callable, &block)

      @mutex = Mutex.new
      @cv = ConditionVariable.new
      @callable = callable
      if block_given?
        @callable = block
      end
    end


    def run
      puts 'EMFuture.run'
      p @callable
      begin
        @callbackable = @callable.call
        puts 'done @callable.call ' + @callbackable.inspect
      rescue Exception => ex
        @ex = ex
      end
      if @ex
        complete
        return
      end

      http = @callbackable
      http.errback2 {
        puts 'completion errback'
        @ex = EventMachineError.new(http)
        complete
      }
      @result = (http.callback2 {
        puts 'completion callback ' + @callback.inspect
        ret = nil
        if @callback
          ret = @callback.call(@callbackable)
        end
        complete
        ret
      })
      puts '@result=' + @result.inspect

    end

    def call
      run
    end

    def complete
      @complete = true
    end


    def complete?
      @complete
    end

    # Returns results. Will wait for thread to complete execution if not already complete.
    def get
#      @thread.value
      while not @complete
        # todo: gotta be a better way
        puts 'sleeping'
        sleep 0.5
      end
      return get_response
    end

    def get_response
      if @ex
        raise @ex
      end
      @result
    end
  end
end
