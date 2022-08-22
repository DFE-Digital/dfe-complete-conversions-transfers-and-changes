FactoryBot.define do
  factory :action, class: "Action" do
    title { "Have you received the land questionnaire?" }
    order { 0 }
    hint { "Select if you have received the land questionnaire" }
    guidance_summary { "Help receiving the land questionnaire" }
    guidance_text do
      "You'll need to [check the guidance (opens in new tab)]" \
      "(https://www.gov.uk/government/publications/academy-land-questionnaires) about the land questionnaire."
    end

    task
  end
end
