FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "日記#{n}日目" }
    content { 'いい感じ！' }
    sequence(:start_time) { |n| Time.zone.today + (n - 1) }
    association :user, strategy: :create
  end
end
