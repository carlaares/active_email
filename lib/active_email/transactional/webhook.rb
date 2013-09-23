module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class Webhook < ActiveRecord::Base
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
    end
  end
end

