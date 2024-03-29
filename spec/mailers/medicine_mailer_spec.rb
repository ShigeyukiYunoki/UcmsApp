# require "rails_helper"
#
# RSpec.describe MedicineMailer, type: :mailer do
#   include ActiveJob::TestHelper
#   describe "take_medicine_email" do
#     let(:user) { FactoryBot.create(:user) }
#     let(:mail) { MedicineMailer.take_medicine(user) }
#
#     it "renders the headers" do
#       expect(mail.subject).to eq("服薬の時間です")
#       expect(mail.to).to eq([user.email])
#       expect(mail.from).to eq(["noreply@www.ucmsapp.com"])
#     end
#   end
# end
