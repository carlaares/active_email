module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    module Base
      # Set ActiveEmail gateways in test mode.
      #
      #   ActiveEmail::Transactional::Base.gateway_mode = :test
      mattr_accessor :gateway_mode

      # Set both the mode of both the gateways and integrations
      # at once
      mattr_reader :mode

      def self.mode=(mode)
        @@mode = mode
        self.gateway_mode = mode
      end

      self.mode = :production

      # A check to see if we're in test mode
      def self.test?
        self.gateway_mode == :test
      end

      # This method is overwritten by subclasses. default behavior is to answer nil.
      def self.process_webhook(params)
        nil
      end
    end
  end
end
