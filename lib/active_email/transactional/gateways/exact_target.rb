module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class ExactTargetGateway < Gateway
      # Specific to ExactTarget options:
      # * <tt>:username</tt> - Username to access Exact target
      # * <tt>:password</tt> - Password to access Exact target
      # * <tt>:endpoint</tt> - Endpoint assigned by Exact target
      # * <tt>:namespace</tt> - Namespace assigned by Exact target
      # * <tt>:business_unit_id</tt> - BU id assigned by Exact target
      # * <tt>:additional_data</tt> - Custom attributes to fill in Subcriber model
      #
      # Standard Active Email options
      # * <tt>:email_address</tt> - The destination email address
      #
      
      def initialize(options = {})
        requires!(options, :username, :password, :endpoint, :namespace)

        begin
          ExactTargetSDK.config(:username => options[:username], 
               :password => options[:password], 
               :endpoint => options[:endpoint],
               :namespace => options[:namespace],
               :open_timeout => 60)
        rescue LoadError
          raise "Could not load the exact_target_sdk gem.  Use `gem 'exact_target_sdk', github: 'stoneacre/exact_target_sdk'` to install it."
        end

        super
      end

      def send(email, options = {})
        trigger_definition = ExactTargetSDK::TriggeredSendDefinition.new({
            'CustomerKey' => email.template_identifier,
            'EmailSubject' => email.subject, 'FromName' => email.from_name,
            'FromAddress' => email.from_email_address
          })

        options[:additional_data].each do |api_field, our_field| 
          attributes << SacExactTarget.format_attribute(enrollment_info, api_field, our_field)
        end  

        s = ExactTargetSDK::Subscriber.new({ 'SubscriberKey' => email.to_email_address, 
          'EmailAddress' => email.to_email_address,
          'Attributes' => attributes })
        trigger_to_send = ExactTargetSDK::TriggeredSend.new(
          'TriggeredSendDefinition' => trigger_definition, 
          'Client' => ExactTargetSDK::SubscriberClient.new(ID: options[:business_unit_id]),
          'Subscribers' => [ s ] )
        client = ExactTargetSDK::Client.new
        answer = client.Create(trigger_to_send)
        build_response(:send, answer)
      end

      private
        def build_response(kind, response)
          Response.new(
              response,
              response.OverallStatus == "OK",
              res.Results.first.status_message, {
              # :transaction_id => first_response['_id'],
              # :test          => test?
            }
          )
        end


    end
  end
end
