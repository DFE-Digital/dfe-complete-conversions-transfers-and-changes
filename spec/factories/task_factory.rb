FactoryBot.define do
  factory :task, class: "Task" do
    title { "Clear land questionnaire" }
    completed { false }
    order { 0 }
    section { create(:section) }
  end
end
