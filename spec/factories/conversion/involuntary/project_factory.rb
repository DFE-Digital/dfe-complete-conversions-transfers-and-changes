FactoryBot.define do
  factory :involuntary_conversion_project, class: "Conversion::Project" do
    type { "Conversion::Project" }
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    provisional_conversion_date { (Date.today + 2.years).at_beginning_of_month }
    advisory_board_date { (Date.today - 2.weeks) }
    establishment_sharepoint_link { "https://educationgovuk-my.sharepoint.com/establishment-folder" }
    trust_sharepoint_link { "https://educationgovuk-my.sharepoint.com/trust-folder" }
    task_list { association :conversion_involuntary_task_list }

    after :create do |project|
      create :involuntary_conversion_project_details, project: project
    end
  end
end
