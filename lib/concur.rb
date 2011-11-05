
require_relative 'executor'
require_relative 'thread_pool'

require 'logger'
module Concur
  @@logger = Logger.new(STDOUT)

  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end

end