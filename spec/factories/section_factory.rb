FactoryBot.define do
  factory :section, class: "Section" do
    title { "Clear legal documents" }
    order { 0 }
    project
  end
end
