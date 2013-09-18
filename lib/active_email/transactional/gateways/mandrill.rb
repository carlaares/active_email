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

      def status(transaction_id)
        answer = @mandrill.messages.info transaction_id
        build_response(:send, answer)
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

      # Madrill webhook test response
      # 2.0.0p195 :011 > message[0]
      #  => {"event"=>"send", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "opens"=>[], "clicks"=>[], "state"=>"sent", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa"}, "ts"=>1379462652} 
      # 2.0.0p195 :013 > message[2]
      #  => {"event"=>"hard_bounce", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "state"=>"bounced", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa", "bounce_description"=>"bad_mailbox", "bgtools_code"=>10, "diag"=>"smtp;550 5.1.1 The email account that you tried to reach does not exist. Please try double-checking the recipient's email address for typos or unnecessary spaces."}, "ts"=>1379462652} 
      # 2.0.0p195 :014 > message[3]
      #  => {"event"=>"soft_bounce", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "state"=>"soft-bounced", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa", "bounce_description"=>"mailbox_full", "bgtools_code"=>22, "diag"=>"smtp;552 5.2.2 Over Quota"}, "ts"=>1379462652} 
      # 2.0.0p195 :015 > message[4]
      #  => {"event"=>"open", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "opens"=>[{"ts"=>1365111111}], "clicks"=>[{"ts"=>1365111111, "url"=>"http://mandrill.com"}], "state"=>"sent", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa"}, "ip"=>"127.0.0.1", "location"=>{"country_short"=>"US", "country"=>"United States", "region"=>"Oklahoma", "city"=>"Oklahoma City", "latitude"=>35.4675598145, "longitude"=>-97.5164337158, "postal_code"=>"73101", "timezone"=>"-05:00"}, "user_agent"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.8) Gecko/20100317 Postbox/1.1.3", "user_agent_parsed"=>{"type"=>"Email Client", "ua_family"=>"Postbox", "ua_name"=>"Postbox 1.1.3", "ua_version"=>"1.1.3", "ua_url"=>"http://www.postbox-inc.com/", "ua_company"=>"Postbox, Inc.", "ua_company_url"=>"http://www.postbox-inc.com/", "ua_icon"=>"http://cdn.mandrill.com/img/email-client-icons/postbox.png", "os_family"=>"OS X", "os_name"=>"OS X 10.6 Snow Leopard", "os_url"=>"http://www.apple.com/osx/", "os_company"=>"Apple Computer, Inc.", "os_company_url"=>"http://www.apple.com/", "os_icon"=>"http://cdn.mandrill.com/img/email-client-icons/macosx.png", "mobile"=>false}, "ts"=>1379462652} 
      # 2.0.0p195 :016 > message[5]
      #  => {"event"=>"click", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "opens"=>[{"ts"=>1365111111}], "clicks"=>[{"ts"=>1365111111, "url"=>"http://mandrill.com"}], "state"=>"sent", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa"}, "ip"=>"127.0.0.1", "location"=>{"country_short"=>"US", "country"=>"United States", "region"=>"Oklahoma", "city"=>"Oklahoma City", "latitude"=>35.4675598145, "longitude"=>-97.5164337158, "postal_code"=>"73101", "timezone"=>"-05:00"}, "user_agent"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.8) Gecko/20100317 Postbox/1.1.3", "user_agent_parsed"=>{"type"=>"Email Client", "ua_family"=>"Postbox", "ua_name"=>"Postbox 1.1.3", "ua_version"=>"1.1.3", "ua_url"=>"http://www.postbox-inc.com/", "ua_company"=>"Postbox, Inc.", "ua_company_url"=>"http://www.postbox-inc.com/", "ua_icon"=>"http://cdn.mandrill.com/img/email-client-icons/postbox.png", "os_family"=>"OS X", "os_name"=>"OS X 10.6 Snow Leopard", "os_url"=>"http://www.apple.com/osx/", "os_company"=>"Apple Computer, Inc.", "os_company_url"=>"http://www.apple.com/", "os_icon"=>"http://cdn.mandrill.com/img/email-client-icons/macosx.png", "mobile"=>false}, "url"=>"http://mandrill.com", "ts"=>1379462652} 
      # 2.0.0p195 :017 > message[6]
      #  => {"event"=>"spam", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "opens"=>[{"ts"=>1365111111}], "clicks"=>[{"ts"=>1365111111, "url"=>"http://mandrill.com"}], "state"=>"sent", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa"}, "ts"=>1379462652} 
      # 2.0.0p195 :018 > message[7]
      #  => {"event"=>"unsub", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "opens"=>[{"ts"=>1365111111}], "clicks"=>[{"ts"=>1365111111, "url"=>"http://mandrill.com"}], "state"=>"sent", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa"}, "ts"=>1379462652} 
      # 2.0.0p195 :019 > message[8]
      #  => {"event"=>"reject", "msg"=>{"ts"=>1365109999, "subject"=>"This an example webhook message", "email"=>"example.webhook@mandrillapp.com", "sender"=>"example.sender@mandrillapp.com", "tags"=>["webhook-example"], "opens"=>[], "clicks"=>[], "state"=>"rejected", "metadata"=>{"user_id"=>111}, "_id"=>"exampleaaaaaaaaaaaaaaaaaaaaaaaaa", "_version"=>"exampleaaaaaaaaaaaaaaa"}, "ts"=>1379462652} 
      # 2.0.0p195 :020 > message[9]
      #
      def self.process_webhook(params)
        return nil unless params.keys.include? 'mandrill_events'
        messages = JSON.parse params['mandrill_events']
        messages.collect do |message|
          if message.include? 'event'
            event = message['event'].gsub('unsub', 'unsubscribe')
            email_id = message['msg']['_id']
            options = {}
            { 'clicked_at' => 'clicks', 'opened_at' => 'opens' }.each do |key, value|
              unless message['msg']['opens'].empty?
                # TODO: shall we answer an array too??
                options.merge!({ key => DateTime.strptime(message['msg'][value].first['ts'].to_s,'%s') })
              end
            end
            Webhook.new(message, event, email_id, options)
          end
        end.compact
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
