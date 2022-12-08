FactoryBot.define do
  factory :land_questionnaire, class: "Conversion::Voluntary::LandQuestionnaire" do
    received { true }
    cleared { true }
    signed_by_solicitor { true }
    saved_in_school_sharepoint { true }
  end
end
