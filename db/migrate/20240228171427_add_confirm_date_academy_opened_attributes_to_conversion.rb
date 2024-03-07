class AddConfirmDateAcademyOpenedAttributesToConversion < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :confirm_date_academy_opened_date_opened, :date
  end
end
