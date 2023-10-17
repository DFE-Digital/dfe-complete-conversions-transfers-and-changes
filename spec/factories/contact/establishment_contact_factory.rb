FactoryBot.define do
  factory :establishment_contact, class: Contact::Establishment do
    name { "Jo Example" }
    title { "CEO of Learning" }

    organisation_name { "Some Organisation" }
    type { "Contact::Establishment" }

    email { "jo@example.com" }
    phone { "01632 960123" }

    establishment_urn { 123456 }
    category { "school_or_academy" }
  end
end
