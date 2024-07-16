class RemoveReasonsFromDaoRevocation < ActiveRecord::Migration[7.0]
  def change
    remove_column :dao_revocations, :reason_school_closed, :boolean
    remove_column :dao_revocations, :reason_school_rating_improved, :boolean
    remove_column :dao_revocations, :reason_safeguarding_addressed, :boolean
  end
end
