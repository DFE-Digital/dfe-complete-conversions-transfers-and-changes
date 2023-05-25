FactoryBot.define do
  factory :funding_agreement_letters, class: Contact::FundingAgreementLetters do
    name { "James Example" }
    title { "Interim Funding Manager" }

    organisation_name { "Some Organisation" }
    type { "Contact::FundingAgreementLetters" }

    email { "james@example.com" }
    phone { "01632 960123" }

    project factory: :conversion_project
  end
end
