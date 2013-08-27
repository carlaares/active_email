module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class LyrisGateway < Gateway
      # Specific to Lyris options:
      #
      # Standard Active Email options
      # * <tt>:email_address</tt> - The destination email address
      #
      self.test_url = ''
      self.live_url = ''
      
      def initialize(options = {})
        # TODO:
      end
    end
  end
end
