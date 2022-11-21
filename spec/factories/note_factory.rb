FactoryBot.define do
  factory :note do
    body { "Just had a very interesting phone call with the headteacher about land law" }

    conversion_project
    user { association :user, email: "user-#{SecureRandom.uuid}@education.gov.uk" }

    trait :task_level_note do
      task
      body { "I really enjoyed performing this task" }
    end
  end
end
