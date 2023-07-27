FactoryBot.define do
  factory :create_transfer_project_form, class: "Transfer::CreateProjectForm" do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    outgoing_trust_ukprn { 10066123 }
    advisory_board_date { {3 => 1, 2 => 10, 1 => 2022} }
    significant_date { {3 => 1, 2 => 10, 1 => 2032} }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    user { association :user, :regional_delivery_officer }
  end
end