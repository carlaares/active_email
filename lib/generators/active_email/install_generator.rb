module ActiveEmail
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_initializer
        active_email_route = "match 'webhook' => 'webhook#index', as: 'active_email_webhook', via: [:get, :post]"
        route active_email_route
        copy_file "webhooks_received.rb", "db/migrate/#{DateTime.now}_webhooks_received.rb"
        copy_file "webhook_controller.rb", "app/controllers/webhook_controller.rb"
      end
    end
  end
end