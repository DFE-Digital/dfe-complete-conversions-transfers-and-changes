FactoryBot.define do
  factory :conversion_project, class: "ConversionProject" do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    provisional_conversion_date { (Date.today + 2.years).at_beginning_of_month }
    team_leader { association :user, :team_leader, email: "team-leader-#{SecureRandom.uuid}@education.gov.uk" }
    regional_delivery_officer { association :user, :regional_delivery_officer, email: "regional-delivery-officer-#{SecureRandom.uuid}@education.gov.uk" }
    advisory_board_date { (Date.today - 2.weeks) }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }

    trait :with_conditions do
      advisory_board_conditions { "The following must be met:\n 1. Must be red\n2. Must be blue\n" }
    end

    trait :without_any_assigned_roles do
      team_leader { nil }
      regional_delivery_officer { nil }
      caseworker { nil }
    end
  end
end
