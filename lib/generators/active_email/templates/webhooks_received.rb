class WebhooksReceived < ActiveRecord::Migration
  def change
    create_table :delayed_jobs, :force => true do |table|
      table.string  :event
      table.string  :transaction_id
      table.text     :raw_message
      table.datetime :event_date
      table.timestamps
    end
  end
end
