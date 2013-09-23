class WebhooksReceived < ActiveRecord::Migration
  def change
    create_table :webhooks, :force => true do |table|
      table.string  :event
      table.string  :transaction_id
      table.text     :raw_message
      table.datetime :event_date
      table.timestamps
    end
  end
end
