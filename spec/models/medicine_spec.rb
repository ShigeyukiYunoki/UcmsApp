require 'rails_helper'

RSpec.describe Medicine, type: :model do
  # factoryが正しければ有効な状態であること
  it 'has a valid factory' do
    expect(build(:medicine)).to be_valid
  end
  # user_idが無ければ無効な状態であること
  it 'is invalid without a user_id' do
    medicine = build(:medicine, user_id: nil)
    medicine.valid?
    expect(medicine.errors[:user_id]).to include('を入力してください')
  end
  # gonna_take_medicine_atが現在時刻より遅い時刻でないと無効な状態であること
  it 'is invalid a gonna_take_medicine_at not later than now' do
    medicine = build(:medicine, gonna_take_medicine_at: Time.now - 60)
    medicine.valid?
    expect(medicine.errors[:gonna_take_medicine_at]).to include('は現在時刻より遅い時間を選択してください!')
  end
  # took_medicine_atが保存されること
  it 'is valid with a took_medicine_at' do
    medicine = create(:medicine, :skip_validate, took_medicine_at: Time.now&.strftime('%Y年%m月%d日'),
                                                 gonna_take_medicine_at: nil)
    expect(medicine).to be_truthy
  end
end
