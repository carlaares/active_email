module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class MandrillGateway < Gateway
      # Specific to Mandril options:
      # * <tt>:api_key</tt> - API Token to access Mandrill
      # * <tt>:async</tt> - Send email async (default: false)
      # * <tt>:send_at</tt> - Schedule this email to be sent on (default: no scheduling)
      # * <tt>:important</tt> - Mark this message as important (default: false)
      # * <tt>:track_opens</tt> - Track opens (default: true)
      # * <tt>:tags</tt> - Tags (default: empty array)
      # * <tt>:track_clicks</tt> - Track clicks (default: true)
      #
      #
      # Standard Active Email options
      #
      #
      
      def initialize(options = {})
        begin
          require 'mandrill'
        rescue LoadError
          raise "Could not load the mandrill-api gem (>= 1.0.41).  Use `gem install mandrill-api` to install it."
        end

        requires!(options, :api_key)

        @mandrill = Mandrill::API.new options[:api_key]

        super
      end

      def send(email, options = {})
        headers = email.reply_to.nil? ? { } : { "Reply-To" => email.reply_to }
        message = {
          "headers"=>headers,
          "from_name"=>email.from_name,
          "from_email"=>email.from_email_address,
          "important"=>(options[:important]||false),
          "preserve_recipients"=>nil,
          "track_opens"=>(options[:track_opens]||true),
          "to"=>[{"name"=>email.to_name, "email"=>email.to_email_address}],
          "subject"=>email.subject,
          "tags"=>[ options[:tags] ], #TODO: validate that tags is an array
          "track_clicks"=>(options[:track_clicks]||true) 
        }
        async = options[:async] || false
        ip_pool = options[:ip_pool] || "Main Pool"
        send_at = options[:send_at]
        answer = @mandrill.messages.send_template email.template_identifier, 
                    [ email.dynamic_content ], message, async, ip_pool, send_at
        build_response(:send, answer)
      end

      private
        def build_response(kind, response)
          first_response = response.first
          Response.new(
              response,
              first_response['status'] == "sent",
              first_response['reject_reason'], {
              :transaction_id => first_response['_id'],
              :test          => test?
            }
          )
        end
    end
  end
end
