class UserMailer < ActionMailer::Base
  default from: "no_reply"

  def verification_email(user)
    @user = user
    mail(to: user.email, subject: "Dictionary registartion")
  end
end
