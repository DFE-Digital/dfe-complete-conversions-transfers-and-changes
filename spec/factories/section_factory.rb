FactoryBot.define do
  factory :section, class: "Section" do
    title { "Conversion Project kick-off" }
    order { 0 }
    conversion_project
  end
end
