FactoryBot.define do
  factory :involuntary_conversion_task_handover, class: "Conversion::Involuntary::Tasks::Handover" do
    review { false }
  end
end
