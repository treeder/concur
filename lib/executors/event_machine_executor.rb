require 'eventmachine'
require_relative '../futures/event_machine_future'

module Concur
  class EventMachineExecutor


    def initialize
      @futures = []
      @em_thread = Thread.new do
        EventMachine.run do
          puts 'Starting EventMachineExecutor...'
#          @futures.each do |f|
#
#          end
        end
        puts 'EventMachine loop done'
      end
    end

    def execute(runnable=nil, &blk)
      f = EventMachineFuture.new(runnable, &blk)
#      @futures = f
      EventMachine.schedule(f)
      f
    end

    def shutdown
      @em_thread.kill
      puts 'shutdown'
    end

  end
end