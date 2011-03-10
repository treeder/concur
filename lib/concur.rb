
require_relative 'executor'

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