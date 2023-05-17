FactoryBot.define do
  factory :project_contact, class: Contact::Project do
    name { "Jo Example" }
    title { "CEO of Learning" }

    organisation_name { "Some Organisation" }
    type { "Contact::Project" }

    email { "jo@example.com" }
    phone { "01632 960123" }

    project factory: :conversion_project
  end
end
