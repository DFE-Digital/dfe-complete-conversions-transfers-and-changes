FactoryBot.define do
  factory :contact do
    name { "Jo Example" }
    title { "CEO of Learning" }

    email { "jo@example.com" }
    phone { "01632 960123" }

    conversion_project
  end
end
