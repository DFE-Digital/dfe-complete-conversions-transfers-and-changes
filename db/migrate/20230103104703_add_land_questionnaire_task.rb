class AddLandQuestionnaireTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :land_questionnaire_received, :boolean
    add_column :conversion_voluntary_task_lists, :land_questionnaire_cleared, :boolean
    add_column :conversion_voluntary_task_lists, :land_questionnaire_signed, :boolean
    add_column :conversion_voluntary_task_lists, :land_questionnaire_saved, :boolean
  end
end
