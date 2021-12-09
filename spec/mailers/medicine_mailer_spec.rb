require "rails_helper"

RSpec.describe MedicineMailer, type: :mailer do
  describe "take_medicine" do
    let(:mail) { MedicineMailer.take_medicine }

    it "renders the headers" do
      expect(mail.subject).to eq("Take medicine")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
