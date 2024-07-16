class AddDaoRevocationReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :dao_revocation_reasons, id: :uuid do |t|
      t.uuid :dao_revocation_id, index: true
      t.string :reason_type
    end
  end
end
