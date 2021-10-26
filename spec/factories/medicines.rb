FactoryBot.define do
  factory :medicine do
    took_medicine_at { nil }
    gonna_take_medicine_at { Time.now + 60 }
    association :user, strategy: :create

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
