class AddDateOpenedAndStatusToGiasEstablishments < ActiveRecord::Migration[7.0]
  def change
    add_column :gias_establishments, :open_date, :date
    add_column :gias_establishments, :status_name, :string
  end
end
