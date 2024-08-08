class AddKeyContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :key_contacts, id: :uuid do |t|
      t.uuid :project_id, index: true
      t.uuid :headteacher_id, index: true
      t.timestamps
    end
  end
end
