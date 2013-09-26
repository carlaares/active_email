active_email
============

NOTE: This gem / plugin was not released yet.

Inspired on ActiveMerchant (Shopify), this plugin is intended to acts as a gateway to connect to mulitple transactional emails providers.

bundle exec rake test:remote 


Installation
============

Add the following line into your Gemfile.
```
gem 'active_email', github: 'carlaares/active_email'
```
Then run this task to install active email files.
```
rails generate active_email:install
````

# Usage

## Send email 

```ruby
api_key = "mandrill api"
gateway = ActiveEmail::Transactional::MandrillGateway.new api_key: api_key
email = Email.new(
  :to_name               => 'Carla',
  :to_email_address      => 'carla.ares@gmail.com',
  :from_name             => 'Carla',
  :from_email_address    => 'carla.ares@gmail.com',
  :template_identifier   => 'template_name',
  :dynamic_content       => { :salutation => 'Ms', :link => 'http://'  },
  :reply_to              => 'carla.ares@gmail.com',
  :subject               => 'Test subject'
)
response = gateway.send(email)
puts response.message
puts response.transaction_id
puts response.success?
```

## Include helpers for each gateway with base configuration
```html
<div class="form-group">
  <%= mandrill_configuration :email_client_configuration, class: "form-control" %>
</div>
```


