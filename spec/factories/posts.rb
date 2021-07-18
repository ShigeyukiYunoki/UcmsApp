FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "日記#{n}日目" }
    content { 'いい感じ！' }
    start_time { Date.today }
    association :user, strategy: :create
  end
end
