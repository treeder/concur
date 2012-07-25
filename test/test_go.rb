gem 'test-unit'
require 'test/unit'
require 'em-http'
require_relative '../lib/concur'
require_relative '../lib/concur/go'
require_relative 'job'


class TestGo < Test::Unit::TestCase

  def test_a
    #@queue = Queue.new
    #x = @queue.pop
    #ch = Concur::Channel.new
    #x = ch.shift
  end

  def test_go

    Concur.config.max_threads = 10

    1.times do |i|
      go do
        puts "hello #{i}"
        sleep 2
        puts "#{i} awoke"
        puts "hhi there"
      end
      puts "done #{i}"
    end

    ch = Concur::Channel.new
    100.times do |i|
      go(ch) do |ch|
        puts "hello channel #{i} #{ch}"
        sleep 2
        # push to channel
        ch << "pushed #{i} to channel"
      end
    end

    puts "waiting on channel..."
    while (x = ch.shift) do
      puts "Got #{x} from channel"
    end

  end

end



