FactoryBot.define do
  factory :project_group do
    trust_ukprn { 1234567 }
    group_identifier { "GRP_12345678" }
  end
end
