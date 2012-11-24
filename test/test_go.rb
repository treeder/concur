gem 'test-unit'
require 'test/unit'
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

    3.times do |i|
      go do
        puts "hello #{i}"
        sleep 1
        puts "#{i} awoke"
        puts "hhi there"
      end
      puts "done #{i}"
    end

    ch = Concur::Channel.new
    times = 10
    times.times do |i|
      20.times do |i|
        go do
          puts "hello channel #{i} #{ch}"
          sleep 1
          # push to channel
          ch << "pushed #{i} to channel"
        end
      end

      puts "waiting on channel..."
      i = 0
      ch.each do |x|
        puts "Got #{x} from channel"
        i += 1
      end
      assert_equal times, i


      # Pass different objects back
      ch = Concur::Channel.new
      times = 10
      times.times do |i|
        go do
          begin
            raise "Error yo!" if i % 5 == 0
            puts "hello channel #{i} #{ch}"
            sleep 1
            # push to channel
            ch << "pushed #{i} to channel"
          rescue => ex
            ch << ex
          end
        end
      end

      puts "waiting on channel..."
      i = 0
      errs = 0
      ch.each do |x|
        puts "Got #{x} from channel"
        i += 1
        case x
          when String
            puts "String"
          when Exception
            puts "Exception!"
            errs += 1
          else
            puts "something else"
        end
        puts "Got from channel: #{x}"
      end
      assert_equal times, i
      assert_equal times / 5, errs

    end

  end

end



