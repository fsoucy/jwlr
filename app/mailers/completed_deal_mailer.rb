class CompletedDealMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.completed_deal_mailer.complaint.subject
  #
  def complaint(user)
    @user = user
    
    mail to: "franksoucy9@gmail.com"
  end
end
