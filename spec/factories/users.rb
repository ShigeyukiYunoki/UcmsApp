# rspecで使うtest用のデータ
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "うみ #{n} あと" }
    sequence(:email) { |n| "ucmsapp#{n}@example.com" }
    seriousness { '中等症' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }

    trait :with_posts do
      after(:create) { |user| create_list(:post, 2, user: user) }
    end
  end
end
