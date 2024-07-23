FactoryBot.define do
  factory :member_of_parliament, class: Contact::Parliament do
    name { "Member Parliament" }
    title { "Member of Parliament for East Ham" }

    organisation_name { "HM Government" }
    type { "Contact::Parliament" }

    email { "member.parliament@parliament.uk" }
    phone { "01632 960123" }

    parliamentary_constituency { "east ham" }
    category { "member_of_parliament" }
  end
end
