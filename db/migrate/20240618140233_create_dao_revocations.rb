class CreateDaoRevocations < ActiveRecord::Migration[7.0]
  def change
    create_table :dao_revocations, id: :uuid do |t|
      t.timestamps
      t.date :date_of_decision
      t.string :decision_makers_name
      t.boolean :reason_school_closed
      t.boolean :reason_school_rating_improved
      t.boolean :reason_safeguarding_addressed
      t.uuid :project_id
    end
  end
end
