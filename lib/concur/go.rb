module Kernel
  def go(ch=nil, &blk)
    future = Concur.gok.executor.execute(nil, ch, &blk)
    future
  end
end

module Concur
  class GoKernel
    def initialize(config)
      @config = config
      @executor = Concur::Executor.new_thread_pool_executor(@config.max_threads)
      @config.add_listener(@executor)
    end

    def executor
      @executor
    end
  end

  @gok = GoKernel.new(Concur.config)

  def self.gok
    @gok
  end

  class Channel
    def initialize
      @queue = Queue.new
    end

    def <<(ob)
      @queue << ob
    end

    def shift
      #begin
        @queue.shift
      #rescue Exception => ex
      #  puts ex.class.name
      #  p ex
      #  if ex.class.name == "fatal"
      #    return nil
      #  end
      #  raise ex
      #end
    end

    def each(&blk)
      while (x = shift) do
        #break if x.nil?
        yield x
      end
    end
  end
end

