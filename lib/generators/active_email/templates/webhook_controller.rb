class WebhookController < ApplicationController
  # skip_before_filter :authenticate_user! # uncomment this line if you are using devise. 
  skip_before_filter :verify_authenticity_token

  def index
    gateways, answer = ActiveEmail::Transactional::Gateway.implementations, nil
    gateways.each do |gateway|
      answer = gateway.send 'process_webhook', params
      next unless answer.nil?
    end

    # variable answer has the GW answer parsed. Add your code here.
    # answer is an array of ActiveEmail::Transactional::Webhook class

    respond_to do |format|
      format.html { render :text => "<html><body>Welcome</body></html>" }
      format.json { render :json => 'Welcome' }
    end
  end
end
