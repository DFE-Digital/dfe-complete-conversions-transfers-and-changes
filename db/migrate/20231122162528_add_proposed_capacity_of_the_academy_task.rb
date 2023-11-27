class AddProposedCapacityOfTheAcademyTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :proposed_capacity_of_the_academy_not_applicable, :boolean
    add_column :conversion_tasks_data, :proposed_capacity_of_the_academy_reception_to_six_years, :string
    add_column :conversion_tasks_data, :proposed_capacity_of_the_academy_seven_to_eleven_years, :string
    add_column :conversion_tasks_data, :proposed_capacity_of_the_academy_twelve_or_above_years, :string
  end
end
