require 'test_helper'

class CompletedDealMailerTest < ActionMailer::TestCase
  test "complaint" do
    mail = CompletedDealMailer.complaint
    assert_equal "Complaint", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
