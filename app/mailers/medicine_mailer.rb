class MedicineMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.medicine_mailer.take_medicine.subject
  #
  def take_medicine(user)
    @user = user

    mail to: user.email, subject: '服薬の時間です'
  end
end
