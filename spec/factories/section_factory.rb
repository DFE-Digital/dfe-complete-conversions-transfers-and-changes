FactoryBot.define do
  factory :section, class: "Section" do
    title { "Project kick-off" }
    order { 0 }
    project factory: :conversion_project
  end
end
