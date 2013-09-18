module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class Webhook
      # Available events:
      # * send
      # * hard_bounce
      # * soft_bounce
      # * open
      # * click
      # * spam
      # * unsubscribe
      # * reject
      #
      # Available options
      # * opened_at
      # * clicked_at
      attr_reader :raw, :event, :id, :options

      def initialize(raw, event, id, options = {})
        @raw, @event, @id, @options = raw, event, id, options
      end
    end
  end
end

