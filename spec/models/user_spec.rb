require 'rails_helper'

RSpec.describe User, type: :model do
  # 姓、名、メール、重症度,パスワード、パスワードの確認があれば有効な状態であること
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'name' do
    # 名がなければ無効な状態であること
    it 'is invalid without a name' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
    end

    # 名が長過ぎると無効な状態であること
    it 'is invalid with a name too long' do
      user = build(:user, name: 'a' * 51)
      user.valid?
      expect(user.errors[:name]).to include('は50文字以内で入力してください')
    end
  end

  describe 'email' do
    # メールアドレスが長過ぎると無効な状態であること
    it 'is invalid with a email too long' do
      user = build(:user, email: 'a' * 244 + '@example.com')
      user.valid?
      expect(user.errors[:email]).to include('は255文字以内で入力してください')
    end

    # メールアドレスがなければ無効な状態であること
    it 'is invalid without an email address' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    # 重複したメールアドレスなら無効な状態であること
    it 'is invalid with a duplicate email address' do
      create(:user, email: 'tester@example.com')
      user = build(:user, email: 'tester@example.com')
      user.valid?
      expect(user.errors[:email]).to include('はすでに存在します')
    end

    # 適したフォーマットならば有効であること
    it 'is valid with a valid format' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        expect(build(:user, email: valid_address)).to be_valid
      end
    end

    # 適さないフォーマットなら無効であること
    it 'is invalid with an invalid format' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        expect(build(:user, email: invalid_address)).to_not be_valid
      end
    end

    # 全て小文字に変換されて保存されること
    it 'is saved as lower-case' do
      user = create(:user, email: 'Foo@ExAMPle.CoM')
      expect(user.reload.email).to eq 'foo@example.com'
    end
  end

  # 重症度がなければ無効な状態であること
  it 'is invalid without a seriousness' do
    user = build(:user, seriousness: nil)
    user.valid?
    expect(user.errors[:seriousness]).to include('を入力してください')
  end

  describe 'password' do
    # パスワードが無ければ無効な状態であること
    it 'is invalid without a password' do
      user = build(:user, password: '')
      user.valid?
      expect(user.errors[:password]).to include('を入力してください')
    end

    # パスワードが７文字以下なら無効な状態であること
    it 'is invalid with a short length' do
      user = build(:user, password: 'a' * 7)
      user.valid?
      expect(user.errors[:password]).to include('は8文字以上で入力してください')
    end
  end

  # ユーザーがdigestをもたなければ承認されないこと

  # ユーザーが削除されると同時にそのユーザーの投稿も削除されること

  # ユーザーが削除されると同時にそのユーザーの服薬記録も削除されること

  # フォローアンフォローが正しく機能していること

  # feedが正しい投稿であること
end
