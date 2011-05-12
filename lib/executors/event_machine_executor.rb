require 'eventmachine'
require_relative '../futures/event_machine_future'

module Concur
  class EventMachineExecutor

    def initialize
      unless EventMachine.reactor_running? # also check EventMachine.reactor_thread? ??
        @in_thread = true
        @em_thread = Thread.new do
          EventMachine.run do
            puts 'Starting EventMachineExecutor...'
#          @futures.each do |f|
#
#          end
          end
          puts 'EventMachine loop done in executor thread'
        end
      else
        puts 'Reactor already running...'
        @in_thread = false
      end
    end

    def execute(runnable=nil, &blk)
      f = EventMachineFuture.new(runnable, &blk)
#      @futures = f
      EventMachine.schedule(f)
      f
    end

    def shutdown
      if @in_thread
        EventMachine.stop
        @em_thread.kill
      end
      puts 'shutdown'
    end

    # Abstracts the http client used that is suitable for the executor
    def http_request(params, &blk)

      f = EventMachineFuture2.new(params, &blk)


    end

  end
end