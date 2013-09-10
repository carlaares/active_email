module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    class Notifier < ActionMailer::Base
      def send_email(email, options = {}, delivery_options = {})
        # @sent_on      = Time.now
        # @content_type = "text/html"
        options = {
          to: "#{email.to_name} <#{email.to_email_address}>", 
          from: "#{email.from_name} <#{email.from_email_address}>",
          subject: email.subject,
          delivery_method_options: delivery_options
        }.merge(email.reply_to.nil? ? {} : { "Reply-To" => email.reply_to })

        mail(options)
      end
    end

    class ActionMailerGateway < Gateway
      # Specific to Mandril options:
      # * <tt>:account_type</tt> - Account type Gmail or Hotmail
      # * <tt>:username</tt> - Account username
      # * <tt>:password</tt> - Account Password
      #
      #
      # Standard Active Email options
      #
      #
      
      def initialize(options = {})
        begin
          require 'actionmailer'
        rescue LoadError
          raise "Could not load the actionmailer gem (>= 4.0).  Use `gem install actionamiler` to install it."
        end

        requires!(options, :username, :password, :account_type)

        if options[:account_type] == "gmail"
          address = "smtp.gmail.com"
          domain = "gmail.com"
        elsif account_type == "hotmail"
          address = "smtp.live.com"
          domain = "hotmail.com"
        else
          raise "Account type unknown"
        end

        @custom_smtp_settings = {
          :address        => address,
          :port           => 587,
          :domain         => domain,
          :authentication => :plain,
          :user_name      => username,
          :password       => password,
          :enable_starttls_auto => true
        }

        super
      end

      def status(transaction_id)
        # Notifier.deliver_envio_mail_gmail(email, cuenta, template.description, template.body, template.attachement, template.attachement_file_name)
#        build_response(:send, answer)
      end

      def send(email, options = {})
        # now this will send using custom SMTP settings
        Notifier.send_email(email, options, @custom_smtp_settings).deliver
        build_response(:send)
      rescue
        build_response(:send, $!)
      end

      private
        def build_response(kind, response = nil)
          Response.new(
              response,
              response.nil?,
              response, 
              { :test => test? }
          )
        end
    end
  end
end
