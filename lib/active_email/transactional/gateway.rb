module ActiveEmail #:nodoc:
  module Transactional #:nodoc:
    #
    # == Description
    # The Gateway class is the base class for all ActiveEmail gateway implementations.
    #
    # The standard list of gateway functions that most concrete gateway subclasses implement is:
    #
    # * <tt>send!(email_address, template_identifier, email_content, options = {})</tt>
    # * <tt>status(email_address_or_transaction_id, options = {})</tt>
    #
    # === Gateway Method Arguments
    # * <tt>:email_address</tt> - Destination Email address
    # * <tt>:template_identifier</tt> - Template identifier (could be an ID or text. According to each gateway implementation)
    #
    # === Gateway Options
    # The options hash consists of the following options:
    #
    #
    class Gateway
      include RequiresParameters
    
      cattr_reader :implementations
      @@implementations = []

      def self.inherited(subclass)
        super
        @@implementations << subclass
      end

      class_attribute :test_url, :live_url

      class_attribute :abstract_class

      self.abstract_class = false

      attr_reader :options

      # Initialize a new gateway.
      #
      # See the documentation for the gateway you will be using to make sure there are no other
      # required options.
      def initialize(options = {})
        @options = options
      end

      # Are we running in test mode?
      def test?
        (@options.has_key?(:test) ? @options[:test] : Base.test?)
      end

      private # :nodoc: all

      def name
        self.class.name.scan(/\:\:(\w+)Gateway/).flatten.first
      end
    end
  end
end
