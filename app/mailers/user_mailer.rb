class UserMailer < ActionMailer::Base
  helper_method :verification_link
  default from: "no_reply"

  def verification_email(user)
    @user = user
    mail(to: user.email, subject: "Dictionary registartion")
  end

  private
  def verification_link(user)
    res = ""
    res << "localhost:3000/user/verification?verification_token=" << user.verification_token
  end
end
