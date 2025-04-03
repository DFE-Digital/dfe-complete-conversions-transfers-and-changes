FactoryBot.define do
  factory :create_conversion_project_form, class: "Conversion::CreateProjectForm", aliases: [:create_project_form] do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    provisional_conversion_date { {3 => 1, 2 => 1, 1 => 2030} }
    advisory_board_date { {3 => 1, 2 => 10, 1 => 2022} }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    incoming_trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    user { association :user, :regional_delivery_officer, strategy: :create }
    handover_note_body { "Handover notes" }
    directive_academy_order { false }
    assigned_to_regional_caseworker_team { false }
    two_requires_improvement { false }

    trait :form_a_mat do
      incoming_trust_ukprn { nil }
      new_trust_reference_number { "TR12345" }
      new_trust_name { "Brand new trust" }
    end
  end
end
