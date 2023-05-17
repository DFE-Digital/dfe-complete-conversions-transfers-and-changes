FactoryBot.define do
  factory :director_of_child_services, class: Contact::DirectorOfChildServices do
    name { "Jake Example" }
    title { "Director of Child Services" }

    type { "Contact::DirectorOfChildServices" }

    email { "jake@example.com" }
    phone { "01632 960123" }

    local_authority factory: :local_authority
  end
end
