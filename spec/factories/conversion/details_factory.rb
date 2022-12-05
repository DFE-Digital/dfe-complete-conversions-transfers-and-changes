FactoryBot.define do
  factory :conversion_details, class: "Conversion::Details" do
    incoming_trust_ukprn { 10061021 }
    project factory: :conversion_project
  end
end
