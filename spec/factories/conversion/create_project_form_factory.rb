FactoryBot.define do
  factory :create_project_form, class: "Conversion::CreateProjectForm" do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    provisional_conversion_date { {3 => 1, 2 => 1, 1 => 2030} }
    advisory_board_date { {3 => 1, 2 => 10, 1 => 2022} }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    user { association :user, :regional_delivery_officer }
    handover_note_body { "Handover notes" }
    directive_academy_order { false }
    assigned_to_regional_caseworker_team { false }
  end
end
