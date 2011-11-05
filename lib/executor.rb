require 'faraday'
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

      def http_request(params, &blk)

        f = StandardFuture.new do
          conn = Faraday.new(:url => params[:base_url]) do |builder|
  #          builder.use Faraday::Request::UrlEncoded # convert request params as "www-form-urlencoded"
  #          builder.use Faraday::Request::JSON # encode request params as json
  #          builder.use Faraday::Response::Logger # log the request to STDOUT
            builder.use Faraday::Adapter::NetHttp # make http requests with Net::HTTP
  #
  #          # or, use shortcuts:
  #          builder.request :url_encoded
  #          builder.request :json
  #          builder.response :logger
  #          builder.adapter :net_http
          end
          if params[:http_method] == :post
            response = conn.post params[:path]
          else
            response = conn.get params[:path]
          end
          if block_given?
            response = blk.call(response)
          end
          response
        end
        @thread_pool.process(f)
        f
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


  end


  # todo: should maybe have these backends extend Executor and just override what's necessary
  class SingleThreaded < Executor::Base
    def process(f)
      f.call
    end

    def execute(f)
      process(f)
    end

    def shutdown
    end
  end

  # Spins off a new thread per job
  class MultiThreaded < Executor::Base
    def process(f)
      @thread = Thread.new do
        f.thread = @thread
        f.call
      end
    end

    def execute(f)
      process(f)
    end

    def shutdown

    end
  end
end
