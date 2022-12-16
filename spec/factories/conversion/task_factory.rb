FactoryBot.define do
  factory :voluntary_conversion_task_handover, class: "Conversion::Voluntary::Tasks::Handover" do
    review { false }
    notes { false }
    meeting { false }
  end
end
