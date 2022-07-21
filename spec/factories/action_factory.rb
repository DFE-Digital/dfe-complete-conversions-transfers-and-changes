FactoryBot.define do
  factory :action, class: "Action" do
    title { "Have you received the land questionnaire?" }
    order { 0 }
    task
  end
end
