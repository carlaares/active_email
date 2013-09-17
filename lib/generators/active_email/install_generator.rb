module ActiveEmail
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path("../templates", __FILE__)

      def copy_initializer
        active_email_route = "get 'webhook/:id' => 'webhook#index', as: 'active_email_webhook'"
        route active_email_route
        copy_file "webhook_controller.rb", "app/controllers/webhook_controller.rb"
      end
    end
  end
end