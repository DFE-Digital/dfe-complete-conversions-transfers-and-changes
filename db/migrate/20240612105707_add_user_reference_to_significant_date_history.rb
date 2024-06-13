class AddUserReferenceToSignificantDateHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :significant_date_histories, :user_id, :uuid, index: true
  end
end
