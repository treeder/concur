require 'logger'

require_relative 'concur/config'
require_relative 'executor'
require_relative 'thread_pool'

module Concur
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO
  @@config = Config.new

  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end

  def self.config
    @@config ||= Config.new
  end

end
