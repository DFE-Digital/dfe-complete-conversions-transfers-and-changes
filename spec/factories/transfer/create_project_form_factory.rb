FactoryBot.define do
  factory :create_transfer_project_form, class: "Transfer::CreateProjectForm" do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    outgoing_trust_ukprn { 10066123 }
    advisory_board_date { {3 => 1, 2 => 10, 1 => 2022} }
    provisional_transfer_date { {3 => 1, 2 => 10, 1 => 2032} }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    incoming_trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/incoming-trust-folder" }
    outgoing_trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/outgoing-trust-folder" }
    user { association :user, :regional_delivery_officer }
    handover_note_body { "This is a handover note." }
    two_requires_improvement { false }
    inadequate_ofsted { false }
  end
end
