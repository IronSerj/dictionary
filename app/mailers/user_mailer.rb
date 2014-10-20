class UserMailer < ActionMailer::Base
  default from: "no_reply"

  def verification_email(user)
    @user = user
    mail(to: user.email, subject: "Dictionary registartion")
  end

  def welcome_message(user, password)
    @user = user
    @password = password
    mail(to: user.email, subject: "Welcome to Dictionary, #{user.login}!")
  end
end
