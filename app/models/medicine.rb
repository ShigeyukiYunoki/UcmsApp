class Medicine < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  # validates :took_medicine_at, on: :save, uniqueness: {scope: :user_id}
  # validates :gonna_take_medicine_at, timeliness: {after: :now, format: '%H:%M:%S'}
  validates :gonna_take_medicine_at, on: :create, presence: true
  validate :start_check, on: :create

  def start_check
    # require "time"
    @gtm = gonna_take_medicine_at&.strftime('%H:%M')
    @tn = Time.now&.strftime('%H:%M')
    # @g = Time.parse(@gtm)
    # @t = Time.parse(@tn)
    errors.add(:gonna_take_medicine_at, 'は現在時刻より遅い時間を選択してください!') if @gtm.blank? || Time.parse(@gtm) < Time.parse(@tn)
  end
end
