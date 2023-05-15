FactoryBot.define do
  factory :voluntary_conversion_project, class: "Conversion::Project", aliases: [:conversion_project] do
    type { "Conversion::Project" }
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    conversion_date { (Date.today + 2.years).at_beginning_of_month }
    advisory_board_date { (Date.today - 2.weeks) }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    assigned_to { association :user, :caseworker, email: "user.#{SecureRandom.uuid}@education.gov.uk" }
    directive_academy_order { false }
    region { Project.regions["london"] }
    regional_delivery_officer { association :user, :regional_delivery_officer }
    tasks_data { association :conversion_tasks_data }

    trait :with_conditions do
      advisory_board_conditions { "The following must be met:\n 1. Must be red\n2. Must be blue\n" }
    end

    trait :without_any_assigned_roles do
      team_leader { nil }
      regional_delivery_officer { nil }
      caseworker { nil }
      assigned_to { nil }
    end

    trait :with_team_lead_and_regional_delivery_officer_assigned do
      team_leader { association :user, :team_leader }
      regional_delivery_officer { association :user, :regional_delivery_officer }
    end

    trait :unassigned do
      assigned_to { nil }
    end

    trait :sponsored do
      directive_academy_order { true }
    end
  end
end
