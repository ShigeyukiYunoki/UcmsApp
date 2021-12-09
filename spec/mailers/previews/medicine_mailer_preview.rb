# Preview all emails at http://localhost:3000/rails/mailers/medicine_mailer
class MedicineMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/medicine_mailer/take_medicine
  def take_medicine
    MedicineMailer.take_medicine
  end

end
