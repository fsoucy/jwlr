class PaymentsController < ApplicationController
  protect_from_forgery :except => [:update] #Otherwise the request from PayPal wouldn't make it to the controller
  
  def update
    response = validate_IPN_notification(request.raw_post)
    case response
    when "VERIFIED"
      if request.payment_status == "Completed"
        deal = Deal.find(request.item_number)
        if !deal.nil?
          if !deal.payment_complete? && deal.agreement_achieved
            if deal.seller.email == request.receiver_email
              if deal.user_proposed_price == request.payment_gross && deal.product.delivery_charge == request.shipping  
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
                         'User-Agent' => "iGold payment processor"
                       ).body
  end
end
