FactoryBot.define do
  factory :date_history, class: Conversion::DateHistory do
    project { association :conversion_project }
    previous_date { Date.today.at_beginning_of_month - 1.month }
    revised_date { previous_date + 2.months }
    note { association :note }
  end
end
