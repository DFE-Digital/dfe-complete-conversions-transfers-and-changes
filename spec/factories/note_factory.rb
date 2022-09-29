FactoryBot.define do
  factory :note do
    body { "Just had a very interesting phone call with the headteacher about land law" }

    project
    user { association :user, email: "user-#{SecureRandom.uuid}@education.gov.uk" }

    trait :task_level_note do
      task
    end
  end
end
