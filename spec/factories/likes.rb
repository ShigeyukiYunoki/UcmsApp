FactoryBot.define do
  factory :like do
    user_id { 1 }
    post_id { 2 }
    # association :user, strategy: :create
    # association :post, strategy: :create
  end
end
