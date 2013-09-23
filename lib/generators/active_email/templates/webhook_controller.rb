class WebhookController < ApplicationController
  # skip_before_filter :authenticate_user! # uncomment this line if you are using devise. 
  skip_before_filter :verify_authenticity_token

  def index
    # TODO: improve GW list to be automatically loaded
    gateways, answers = [ 'MandrillGateway' ], []
    gateways.each do |gateway|
      next unless answers.empty?
      begin
        answers = eval('ActiveEmail::Transactional::'+gateway).process_webhook params
        answers.map &:save
      rescue NoMethodError
        # logger.error $!.backtrace
      end
    end

    # variable answer has the GW answer parsed. Add your code here.
    # answer is an array of ActiveEmail::Transactional::Webhook class

    respond_to do |format|
      format.html { render :text => "<html><body>Welcome</body></html>" }
      format.json { render :json => 'Welcome' }
    end
  end
end
