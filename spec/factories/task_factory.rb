FactoryBot.define do
  factory :task, class: "Task" do
    title { "Have you cleared the Supplementary funding agreement?" }
    hint do
      "Check the Supplementary funding agreement for changes from the model documents." \
      "[View the model documents (opens in new tab)](https://www.gov.uk/government/collections/convert-to-an-academy-documents-for-schools)."
    end
    guidance_summary { "Help checking for changes" }
    guidance_text do
      "You'll need to [contact the policy team (opens in new tab)]" \
      "(https://educationgovuk.sharepoint.com/sites/lvedfe00116/SitePages/Commissioning%20Form.aspx) about changes to clause text."
    end
    completed { false }
    order { 0 }

    section
    optional { false }

    trait :optional do
      optional { true }
    end
  end
end
