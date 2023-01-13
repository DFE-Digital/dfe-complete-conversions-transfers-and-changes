FactoryBot.define do
  factory :contact do
    name { "Jo Example" }
    title { "CEO of Learning" }

    organisation_name { "Some Organisation" }

    email { "jo@example.com" }
    phone { "01632 960123" }

    project factory: :conversion_project
  end
end
