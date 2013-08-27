module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    # An +Email+ object represents an email content
    #
    # == Example Usage
    #   email = Email.new(
    #     :to_name                 => 'Carla',
    #     :to_email_address        => 'carla.ares@gmail.com',
    #     :from_name               => 'Carla',
    #     :from_email_address      => 'carla.ares@gmail.com',
    #     :html_content            => '<html><h1>Hi <strong>message</strong>, how are you?</h1></html>',
    #     :dynamic_content         => { :salutation => 'Ms', :link => 'http://'  },
    #     :reply_to                => 'carla.ares@gmail.com',
    #     :subject                 => 'Test subject'
    #   )
    #
    #   email = Email.new(
    #     :to_name               => 'Carla',
    #     :to_email_address      => 'carla.ares@gmail.com',
    #     :from_name             => 'Carla',
    #     :from_email_address    => 'carla.ares@gmail.com',
    #     :template_identifier   => 'template_name',
    #     :dynamic_content       => { :salutation => 'Ms', :link => 'http://'  },
    #     :reply_to              => 'carla.ares@gmail.com',
    #     :subject               => 'Test subject'
    #   )
    #
    class Email
      # Returns or sets the destination name
      #
      # @return [String]
      attr_accessor :to_name

      # Returns or sets the destination email address 
      #
      # @return [String]
      attr_accessor :to_email_address

      # Returns or sets the from name
      #
      # @return [String]
      attr_accessor :from_name

      # Returns or sets the from email address 
      #
      # @return [String]
      attr_accessor :from_email_address

      # Returns or sets the html content
      #
      # @return [String]
      attr_accessor :html_content

      # Returns or sets the template identifier (Sometimes its an id otherwise a template name)
      #
      # @return [String]
      attr_accessor :template_identifier

      # Returns or sets the dynamic content
      #
      # @return [Hash]
      attr_accessor :dynamic_content

      # Returns or sets the reply to address
      #
      # @return [String]
      attr_accessor :reply_to

      # Returns or sets the subject
      #
      # @return [String]
      attr_accessor :subject

      def initialize(args)
        args.each {|key, value| self.send(key.to_s+'=', value)}
        dynamic_content = {}
      end

      # Validates the email details.
      #
      # Any validation errors are added to the {#errors} attribute.
      def validate
        errors.add :template_identifier, "or html_content must have data. Can't be both at the same time" if not template_identifier.blank? and not html_content.blank?
        errors.add :template_identifier, "is required or set html_content" if template_identifier.blank? and html_content.blank?
        errors.add :email_address, "is required" if email_address.blank?
      end

    end
  end
end
