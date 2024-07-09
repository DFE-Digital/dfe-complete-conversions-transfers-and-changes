FactoryBot.define do
  factory :date_history, class: SignificantDateHistory do
    user { association :user, email: "user-#{SecureRandom.uuid}@education.gov.uk" }
    project { association :conversion_project }
    previous_date { Date.today.at_beginning_of_month - 1.month }
    revised_date { previous_date + 2.months }
    note { association :note }
  end

  factory :date_history_reason, class: SignificantDateHistoryReason do
    significant_date_history { association :date_history }
    reason_type { :legacy_reason }
    note { association :note }
  end
end
