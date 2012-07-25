require 'thread'

@queue = Queue.new
100.times do |i|
  Thread.new do
    @queue << "hi"
  end
end

puts "waiting on channel..."
while (x = @queue.pop(true)) do
  puts "Got #{x} from channel"
end
