require 'eventmachine'

module Concur
  class EventMachineExecutor

    def initialize
      @em_thread = Thread.new do
        EventMachine.run do
          puts 'Starting EventMachineExecutor...'
        end
      end
    end

    def execute(runnable=nil, &blk)
      f = Future.new(runnable, &blk)
      EventMachine.schedule(f)
      f

    end

    def shutdown
      @em_thread.kill
      puts 'shutdown'
    end

  end
end