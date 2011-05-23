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
        @callblk = block
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
      @callblk = blk
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
        @result = []
        if @callblk
          @result = @callblk.call(@callbackable)
        end
        blk.call(@result)
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

  class HttpResponseWrapper
    def initialize(em_http)
      @em_http = em_http
    end

    def headers
      @em_http.response_header
    end

    def body
      @em_http.response
    end

    def status
      @em_http.response_header.status
    end

  end

  class EventMachineFuture2
    require 'em-http'
    include Concur::Future

    attr_accessor :ex, :result

    def initialize(http_data, &block)
      @http_data = http_data
      if block_given?
        @blk = block
      end

      puts 'http_data=' + http_data.inspect

      req = EventMachine::HttpRequest.new(http_data[:base_url])

      opts = {:timeout => http_data[:timeout], :head => http_data[:headers]} #, :ssl => true

      if http_data[:http_method] == :post
        http = req.post opts.merge(:path=>http_data[:path], :body=>http_data[:body])
      else
        http = req.get opts.merge(:path=>http_data[:path], :query=>http_data[:query])
      end

      if http.error.empty?
        http.errback {
          begin
            puts 'Uh oh'
            p http.response_header.status
            p http.response_header
            p http.response
            @ex = StandardError.new("ERROR: #{http.response_header.status} #{http.response}")
          rescue => ex
            @ex = ex
          end
          self.complete
        }
        http.callback {
          begin
            puts 'success callback'
#            puts 'status=' + http.response_header.status
#            puts 'response header=' + http.response_header
            if @blk
              @result = @blk.call(HttpResponseWrapper.new(http))
            else
              @result = HttpResponseWrapper.new(http)
            end
          rescue => ex
            @ex = ex
          end
          self.complete
        }
      else
        p http.error.inspect
        @ex = StandardError.new(http.error)
        self.complete
      end


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
#      if !@complete
#        # todo: gotta be a better way
##          puts 'sleeping'
##          sleep 0.1
#        @fiber = Fiber.new do
#          while !@complete
#            sleep 0.1
#          end
#          Fiber.yield # give back control
#        end
#        @fiber.resume # start fiber
#      end
      while !@complete
        sleep 0.1
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

  class EventMachineFuture
    include Concur::Future

    attr_accessor :ex, :result

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
        @callbackable = @callable.call(self)
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
      @result = (http.callback2 { |result|
        puts 'completion errback'
        @result = result
        complete
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
      while !@complete
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
