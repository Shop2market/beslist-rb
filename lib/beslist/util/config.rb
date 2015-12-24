module Beslist
  module API

    module Config

      class << self
        attr_accessor :endpoint
        attr_accessor :prefix
        attr_accessor :mode
      end

      self.endpoint     = "https://www.beslist.nl"
      self.prefix       = "/xml"
      self.mode         = 'sandbox'

    end

  end
end
