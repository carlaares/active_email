require 'test_helper'

class RemoteMandrillTest < Test::Unit::TestCase
  def setup
    @gateway = ActiveEmail::Transactional::MandrillGateway.new(fixtures(:mandrill))
    @email_with_html = ActiveEmail::Transactional::Email.new(
      :to_name                 => 'Carla',
      :to_email_address        => 'carla.ares@gmail.com',
      :from_name               => 'Carla',
      :from_email_address      => 'carla.ares@gmail.com',
      :html_content            => '<html><h1>Hi <strong>message</strong>, how are you?</h1></html>',
      :dynamic_content         => { :salutation => 'Ms', :link => 'http://'  },
      :reply_to                => 'carla.ares@gmail.com',
      :subject                 => 'Test subject'
    )
  
    @email_with_template = ActiveEmail::Transactional::Email.new(
      :to_name               => 'Carla',
      :to_email_address      => 'carla.ares@gmail.com',
      :from_name             => 'Carla',
      :from_email_address    => 'carla.ares@gmail.com',
      :template_identifier   => 'test',
      :dynamic_content       => { :salutation => 'Ms', :link => 'http://'  },
      :reply_to              => 'carla.ares@gmail.com',
      :subject               => 'Test subject'
    )
  end

  def test_send_email_with_template
    response = @gateway.send @email_with_template
    assert response.success?
  end

  def test_send_email_with_html
    # @gateway.send @email_with_html
  end

end
