FactoryBot.define do
  factory :create_project_form, class: "Conversion::CreateProjectForm" do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    provisional_conversion_date { (Date.today + 2.years).at_beginning_of_month }
    advisory_board_date { (Date.today - 2.weeks) }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    user { association :user, :regional_delivery_officer }
  end

  factory :create_involuntary_project_form, parent: :create_project_form, class: "Conversion::Involuntary::CreateProjectForm" do
  end

  factory :create_voluntary_project_form, parent: :create_project_form, class: "Conversion::Voluntary::CreateProjectForm" do
  end
end
