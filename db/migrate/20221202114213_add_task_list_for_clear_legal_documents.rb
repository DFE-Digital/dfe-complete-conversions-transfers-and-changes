class AddTaskListForClearLegalDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :task_lists, id: :uuid do |t|
      t.boolean :land_questionnaire_received
      t.boolean :land_questionnaire_cleared
      t.boolean :land_questionnaire_signed_by_solicitor
      t.boolean :land_questionnaire_saved_in_school_sharepoint
      t.boolean :land_registry_title_plans_received
      t.boolean :land_registry_title_plans_cleared
      t.boolean :land_registry_title_plans_saved_in_school_sharepoint
      t.boolean :supplemental_funding_agreement_received
      t.boolean :supplemental_funding_agreement_cleared
      t.boolean :supplemental_funding_agreement_signed_by_school
      t.boolean :supplemental_funding_agreement_saved_in_school_sharepoint
      t.boolean :supplemental_funding_agreement_sent_to_team_leader
      t.boolean :supplemental_funding_agreement_document_signed
      t.boolean :church_supplemental_agreement_not_applicable
      t.boolean :church_supplemental_agreement_received
      t.boolean :church_supplemental_agreement_cleared
      t.boolean :church_supplemental_agreement_signed_by_school
      t.boolean :church_supplemental_agreement_signed_by_diocese
      t.boolean :church_supplemental_agreement_saved_in_school_sharepoint

      t.references :project, index: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
