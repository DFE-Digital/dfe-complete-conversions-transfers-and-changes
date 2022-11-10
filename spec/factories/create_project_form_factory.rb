FactoryBot.define do
  factory :create_project_form do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    target_conversion_date { {3 => 1, 2 => 1, 1 => 2025} }
    advisory_board_date { {3 => 1, 2 => 10, 1 => 2022} }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    user { association :user, :regional_delivery_officer }
  end
end
