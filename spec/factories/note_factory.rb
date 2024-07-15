FactoryBot.define do
  factory :note do
    body { "Just had a very interesting phone call with the headteacher about land law" }

    project factory: :conversion_project
    user { association :user, email: "user-#{SecureRandom.uuid}@education.gov.uk" }

    trait :task_level_note do
      task_identifier { "handover" }
      body { "I really enjoyed performing this task" }
    end

    trait :for_significant_date_history_reason do
      notable { association :date_history_reason }
      body { "This is the reason the conversion date has changed" }
    end
  end
end
