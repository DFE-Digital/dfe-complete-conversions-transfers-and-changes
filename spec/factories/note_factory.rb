FactoryBot.define do
  factory :note do
    body { "Just had a very interesting phone call with the headteacher about land law" }

    project factory: :conversion_project
    user { association :user, email: "user-#{SecureRandom.uuid}@education.gov.uk" }

    trait :task_level_note do
      task_identifier { "handover" }
      body { "I really enjoyed performing this task" }
    end
  end
end
