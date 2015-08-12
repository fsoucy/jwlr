# Preview all emails at http://localhost:3000/rails/mailers/completed_deal_mailer
class CompletedDealMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/completed_deal_mailer/complaint
  def complaint
    CompletedDealMailer.complaint
  end

end
