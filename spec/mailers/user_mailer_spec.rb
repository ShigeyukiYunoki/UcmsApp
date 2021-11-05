require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  include ActiveJob::TestHelper
  describe 'account_activation_email' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "sends a email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the support email address' do
      expect(mail.from).to eq ['noreply@www.ucmsapp.com']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq 'アカウントの有効化'
    end
  end

  describe 'password_reset_email' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.create_reset_digest
    end
    it "sends a email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the support email address' do
      expect(mail.from).to eq ['noreply@www.ucmsapp.com']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq 'パスワードの再設定'
    end
  end
end
