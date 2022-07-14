FactoryBot.define do
  factory :academies_api_establishment, class: "AcademiesApi::Establishment" do
    transient do
      name { "Caludon Castle School" }
    end

    initialize_with { new(JSON.generate(api_response_mapping)) }
  end
end

private def api_response_mapping
  {establishmentName: name}
end
