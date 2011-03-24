
require 'neverblock'

# This doesn't work as expected. Not sure how to get it to non block on the IO calls

module Concur
  class NeverBlockExecutor

    def initialize(max_size)
      @fiber_pool = NeverBlock::Pool::FiberPool.new(max_size)
    end

    def execute(runnable=nil, &blk)
      f = Future.new(runnable, &blk)
      @fiber_pool.spawn do
          puts 'running in spawn'
        f.call
      end
      f
    end

    def shutdown

    end

  end
end
