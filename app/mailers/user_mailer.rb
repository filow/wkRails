class UserMailer < ApplicationMailer
  default from: "service@tiien.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "水利资源大赛网站账户激活验证"
  end
end
