class Conversion::Voluntary::TaskList < ApplicationRecord
  belongs_to :project, inverse_of: :task_list

  composed_of \
    :land_questionnaire,
    class_name: "Conversion::Voluntary::LandQuestionnaire",
    mapping: [
      %w[land_questionnaire_received received],
      %w[land_questionnaire_cleared cleared],
      %w[land_questionnaire_signed_by_solicitor signed_by_solicitor],
      %w[land_questionnaire_saved_in_school_sharepoint saved_in_school_sharepoint]
    ],
    constructor: :compose
end
