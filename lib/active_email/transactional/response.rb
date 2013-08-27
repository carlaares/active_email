module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class Response
      attr_reader :raw, :params, :message, :test, :transaction_id

      def success?
        @success
      end

      def test?
        @test
      end

      def initialize(raw, success, message, params = {}, options = {})
        @raw, @success, @message, @params = raw, success, message, params.stringify_keys
        @test = options[:test] || false
        @transaction_id = options[:transaction_id]
      end
    end
  end
end
