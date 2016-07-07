class Deal < ActiveRecord::Base
  belongs_to :product
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User"
  belongs_to :selling_method
  belongs_to :exchange_method
  belongs_to :payment_method
  has_many :reviews

  def status(seller)
    # returns a list [message, action needed]
    # [long message, short message, long message]
    # refresh action panel continuously
    if self.complaint_buyer
      if seller
        return ["A complaint has been filed.", true]
      else
        return ["You have filed a complaint.", true]
      end
    elsif self.complaint_seller
      if seller
        return ["You have filed a complaint.", true]
      else
        return ["A complaint has been filed.", true]
      end
    else
      if self.deal_complete
        if (self.reviews.where("user_id=?", self.seller_id).length == 0 and seller)
          # seller needs to give a review
          msg = "Deal completed! Please leave a review."
          return [msg, true]
        elsif (self.reviews.where("user_id=?", self.buyer_id).length == 0 and buyer)
          # buyer needs to give a review
          msg = "Deal completed! Please leave a review."
          return [msg, true]
        else
          msg = "Congratulations on your completed deal!"
          return [msg, false]
        end
      else
        # deal not complete
        if (self.selling_method.nil? or self.exchange_method.nil? or self.payment_method.nil?)
          if seller
            msg = "Buyer needs to select methods of transaction."
            return [msg, false]
          else
            msg = "You need to select methods of transaction."
            return [msg, true]
          end
        else
          if (self.selling_method.method == "Negotiation" && !self.proposed_price_accepted)
            if (self.user_proposed_price.nil? or !(self.user_proposed_price > 0.0))
              if seller
                return ["Buyer needs to make an offer.", false]
              else
                return ["You still need to make an offer.", true]
              end
            else
              if seller
                return ["Check out the buyer's offer.", true]
              else
                return ["The seller has not yet accepted your offer.", false]
              end
            end
          else
            if self.agreement_achieved
              if self.exchange_method.method == "Delivery"
                if self.payment_complete
                  if self.product_dispatched
                    if self.product_received
                      # just needs confirmation
                      if seller
                        if self.seller_satisfied
                          return ["Waiting on buyer's confirmation of a successful deal.", false]
                        else
                          return ["Confirm successful deal.", true]
                        end
                      else
                        if self.buyer_satisfied
                          return ["Waiting on seller's confirmation of a successful deal.", false]
                        else
                          return ["Confirm successful deal.", true]
                        end
                      end
                    else
                      if seller
                        return ["Buyer has not yet received the product.", false]
                      else
                        return ["Let us know when you receive the product.", true]
                      end
                    end
                  else
                    if seller
                      return ["Dispatch the product.", true]
                    else
                      return ["Waiting on seller to dispatch the product.", false]
                    end
                  end
                else
                  if self.product_dispatched
                    if self.product_received
                      if seller
                        return ["The buyer has received the product but not yet made the payment.", false]
                      else
                        return ["You need to make the payment.", true]
                      end
                    else
                      if seller
                        return ["The buyer has not yet received the product or made the payment.", false]
                      else
                        return ["The product is on its way, but you have not made your payment.", true]
                      end
                    end
                  else
                    if seller
                      return ["You have not dispatched the product and the buyer has not made the payment.", false]
                  else
                    return ["The seller has not dispatched the product and you have not made the payment.", true]
                    end
                  end
                end
              elsif (self.exchange_method.method == "Pickup" or self.exchange_method.method == "Meetup")
                if self.payment_complete
                  if self.product_received
                    # just needs confirmation
                    if seller
                      if self.seller_satisfied
                        return ["Waiting on buyer success confirmation.", false]
                      else
                        return ["Confirm successful transaction.", true]
                      end
                    else
                      if self.buyer_satisfied
                        return ["Waiting on seller success confirmation.", false]
                      else
                        return ["Confirm successful transaction.", true]
                      end
                    end
                  else
                    if seller
                      return ["Waiting for buyer to mark product as received.", false]
                    else
                      return ["Let us know when you receive the product.", true]
                    end
                  end
                else
                  if self.product_received
                    if seller
                      return ["Let us know when you've been paid.", true]
                    else
                      return ["Waiting on the seller to mark payment as received.", false]
                    end
                  else
                    if seller
                      return ["Let us know when you've been paid.", true]
                    else
                      return ["Let us know when you've received your product.", true]
                    end
                  end
                end
              end
            else
              if (self.exchange_method.method == "Delivery" or self.exchange_method.method == "Pickup")
                if seller
                  return ["Waiting for buyer to confirm interest.", false]
                else
                  return ["Confirm interest in deal.", true]
                end
              else
                if seller
                  return ["Establish meetup agreement.", true]
                else
                  return ["Establish meetup agreement.", true]
                end
              end
            end
          end
        end
      end
    end  
  end
end
