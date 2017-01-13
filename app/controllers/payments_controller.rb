class PaymentsController < ApplicationController
  protect_from_forgery :except => [:update] #Otherwise the request from PayPal wouldn't make it to the controller
  
  def create
    response = validate_IPN_notification(request.raw_post)
    case response
    when "VERIFIED"
      if params[:payment_status] == "Completed"
        deal = Deal.find(params[:item_number])
        if !deal.nil?
          if !deal.payment_complete? && deal.agreement_achieved?
            if deal.seller.email == params[:receiver_email]
              if deal.product.delivery_cost.nil?
                 deal.product.delivery_cost = 0
              end
              if (deal.user_proposed_price + deal.product.delivery_cost) == params[:payment_gross].to_f  
                deal.payment_complete = true
                deal.save            
              end
            end
          end
        end
      end

      # check that paymentStatus=Completed
      # check that txnId has not been previously processed
      # check that receiverEmail is your Primary PayPal email
      # check that paymentAmount/paymentCurrency are correct
      # process payment
    when "INVALID"
      # log for investigation
    else
      # error
    end
    render :nothing => true
  end 
 
  protected 
    def validate_IPN_notification(raw)
      uri = URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 60
      http.read_timeout = 60
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.use_ssl = true
      response = http.post(uri.request_uri, raw,
                         'Content-Length' => "#{raw.size}",
                         'User-Agent' => "jwlr payment processor"
                       ).body
  end
end
