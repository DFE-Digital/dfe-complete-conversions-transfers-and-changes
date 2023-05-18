class AddConversionAcademyDetailsTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :academy_details_name, :string
  end
end
