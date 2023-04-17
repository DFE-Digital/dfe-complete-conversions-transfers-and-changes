FactoryBot.define do
  factory :members_api_name, class: "Api::MembersApi::MemberName" do
    id { 1234 }
    name_list_as { "Smith, Jane" }
    name_display_as { "Jane Smith" }
    name_full_title { "Jane Smith MP" }
    name_address_as { "Jane Smith" }
  end
end
