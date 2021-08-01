FactoryBot.define do
  factory :like do
    user_id { nil }
    post_id { nil }
    # association :user, strategy: :create
    # association :post, strategy: :create
  end
end
