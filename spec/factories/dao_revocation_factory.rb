FactoryBot.define do
  factory :dao_revocation do
    project { association :conversion_project }
    decision_makers_name { "Minister Name" }
    date_of_decision { Date.today - 1.week }
    reason_school_rating_improved { false }
    reason_safeguarding_addressed { false }
    reason_school_closed { true }
  end
end
