class AddConverionProject < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_projects, id: :uuid do |t|
      t.timestamps
    end
  end
end
