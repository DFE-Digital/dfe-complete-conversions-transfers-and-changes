FactoryBot.define do
  factory :dao_revocation do
    project { association :conversion_project, directive_academy_order: true }
    decision_makers_name { "Education Minister" }
    date_of_decision { Date.today - 1.week }

    after(:create) do |dao_revocation, context|
      create(:dao_revocation_reason, dao_revocation: dao_revocation)
    end
  end

  factory :dao_revocation_reason do
    dao_revocation { association :dao_revocation }
    reason_type { :reason_school_closed }
    note {
      association :note,
        project: dao_revocation.project,
        notable: instance,
        user: dao_revocation.project.assigned_to,
        body: "Details of why the school is closing."
    }
  end
end
