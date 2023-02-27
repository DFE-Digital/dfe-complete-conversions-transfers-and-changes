class CreateAllConfirmedConversionDatesView < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      DROP VIEW IF EXISTS all_confirmed_conversion_dates
    SQL

    execute <<-SQL
      CREATE VIEW all_confirmed_conversion_dates AS 
      SELECT stakeholder_kick_off_confirmed_conversion_date,id 
      FROM conversion_involuntary_task_lists 
      UNION SELECT stakeholder_kick_off_confirmed_conversion_date,id 
      FROM conversion_voluntary_task_lists
    SQL
  end
end
