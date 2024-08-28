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

    trait :for_dao_revocation_reason do
      notable { association :dao_revocation_reason }
      body { "The DAO has been revoked" }
    end
  end
end
