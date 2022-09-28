class AddTypeToAction < ActiveRecord::Migration[7.0]
  def change
    add_column :actions, :action_type, :string
    Action.update_all(action_type: "single-checkbox")
  end
end
