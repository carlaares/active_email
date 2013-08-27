module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class AmazonSesGateway < Gateway
      # Specific to Amazon SES options:
      #
      # Standard Active Email options
      # * <tt>:email_address</tt> - The destination email address
      #
      self.test_url = ''
      self.live_url = ''
      
      def initialize(options = {})
        begin
          require 'aws-sdk'
        rescue LoadError
          raise "Could not load the aws-sdk gem (>= xxxx).  Use `gem install aws-sdk` to install it."
        end

        requires!(options, :login, :password)

        @ses = AWS::SimpleEmailService.new(
                  :access_key_id => options[:login],
                  :secret_access_key => options[:password])

        super
      end
    end
  end
end
