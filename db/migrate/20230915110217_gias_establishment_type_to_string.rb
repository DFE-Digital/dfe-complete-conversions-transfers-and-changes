class GiasEstablishmentTypeToString < ActiveRecord::Migration[7.0]
  def up
    change_column :gias_establishments, :type_code, :string
    change_column :gias_establishments, :local_authority_code, :string
    change_column :gias_establishments, :phase_code, :string
    change_column :gias_establishments, :establishment_number, :string
  end

  def down
    change_column :gias_establishments, :type_code, :integer
    change_column :gias_establishments, :local_authority_code, :integer
    change_column :gias_establishments, :phase_code, :integer
    change_column :gias_establishments, :establishment_number, :integer
  end
end
