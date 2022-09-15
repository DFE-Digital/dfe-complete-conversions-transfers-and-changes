class AddAdvisoryBoardAttributesToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :advisory_board_date, :date
    add_column :projects, :advisory_board_conditions, :text
  end
end
