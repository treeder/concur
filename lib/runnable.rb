
# A mixin for runnable classes.
module Concur
  module Runnable
    def run
      raise "No run method defined in your runable!"
    end

    def call
      run
    end
  end
end
