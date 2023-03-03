FactoryBot.define do
  factory :voluntary_conversion_project, class: "Conversion::Project", aliases: [:conversion_project] do
    type { "Conversion::Project" }
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    provisional_conversion_date { (Date.today + 2.years).at_beginning_of_month }
    conversion_date { nil }
    advisory_board_date { (Date.today - 2.weeks) }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    task_list { association :voluntary_conversion_task_list }
    assigned_to { nil }

    trait :with_conditions do
      advisory_board_conditions { "The following must be met:\n 1. Must be red\n2. Must be blue\n" }
    end

    trait :without_any_assigned_roles do
      team_leader { nil }
      regional_delivery_officer { nil }
      caseworker { nil }
    end

    trait :with_team_lead_and_regional_delivery_officer_assigned do
      team_leader { association :user, :team_leader }
      regional_delivery_officer { association :user, :regional_delivery_officer }
    end
  end
end
