FactoryBot.define do
  factory :form_a_mat_conversion_project, class: "Conversion::Project" do
    type { "Conversion::Project" }
    urn { rand(111111..999999) }
    new_trust_reference_number { "TR12345" }
    new_trust_name { "The New Trust" }
    conversion_date { (Date.today + 2.years).at_beginning_of_month }
    advisory_board_date { (Date.today - 2.weeks) }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    incoming_trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/incoming-trust-folder" }
    assigned_to { association :user, :caseworker, email: "user.#{SecureRandom.uuid}@education.gov.uk" }
    directive_academy_order { false }
    region { Project.regions["london"] }
    regional_delivery_officer { association :user, :regional_delivery_officer }
    tasks_data { association :conversion_tasks_data }
    team { Project.teams["london"] }
    all_conditions_met { nil }
  end
end
