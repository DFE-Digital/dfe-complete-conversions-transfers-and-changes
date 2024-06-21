FactoryBot.define do
  factory :members_api_contact_details, class: "Api::MembersApi::MemberContactDetails" do
    line1 { "House of Commons" }
    line2 { "London" }
    postcode { "SW1A 0AA" }
    phone { "020 77777777" }
    email { "jane.smith.mp@parliament.uk" }
  end
end
