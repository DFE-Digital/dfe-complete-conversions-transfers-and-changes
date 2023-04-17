FactoryBot.define do
  factory :members_api_contact_details, class: "Api::MembersApi::MemberContactDetails" do
    type { "Parliamentary office" }
    type_description { "" }
    type_id { 1 }
    is_preferred { true }
    is_web_address { false }
    notes { "" }
    line1 { "House of Commons" }
    line2 { "London" }
    postcode { "SW1A 0AA" }
    phone { "020 77777777" }
    email { "jane.smith.mp@parliament.uk" }
  end
end
