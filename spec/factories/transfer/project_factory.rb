FactoryBot.define do
  factory :transfer_project, class: "Transfer::Project" do
    type { "Transfer::Project" }
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    transfer_date { (Date.today + 2.years).at_beginning_of_month }
    advisory_board_date { (Date.today - 2.weeks) }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    incoming_trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/incoming-trust-folder" }
    outgoing_trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/outgoing-trust-folder" }
    assigned_to { association :user, :caseworker, email: "user.#{SecureRandom.uuid}@education.gov.uk" }
    directive_academy_order { false }
    region { Project.regions["london"] }
    regional_delivery_officer { association :user, :regional_delivery_officer }
    tasks_data { association :transfer_tasks_data }
    outgoing_trust_ukprn { 10059062 }
    two_requires_improvement { false }

    trait :form_a_mat do
      incoming_trust_ukprn { nil }
      new_trust_name { "The New Trust" }
      new_trust_reference_number { "TR12345" }
    end
  end
end
