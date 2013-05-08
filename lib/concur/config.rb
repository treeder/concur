module Concur
  class Config
    attr_reader :defaults

    def initialize(options={})
      init_defaults
      @listeners = []
      @max_threads = options[:max_threads] || defaults[:max_threads]
    end

    def init_defaults
      @defaults = {
          max_threads: 20
      }
    end

    def max_threads=(x)
      @max_threads = x
      notify_listeners(:max_threads=>x)
    end

    def max_threads
      @max_threads
    end

    def add_listener(l)
      @listeners << l
    end

    def notify_listeners(changes)
      @listeners.each do |l|
        l.update(changes)
      end
    end
  end
end
