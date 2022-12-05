FactoryBot.define do
  factory :academies_api_trust, class: "AcademiesApi::Trust" do
    ukprn { "10061021" }
    original_name { "THE ROMERO CATHOLIC ACADEMY" }
    companies_house_number { "09702162" }
  end
end
