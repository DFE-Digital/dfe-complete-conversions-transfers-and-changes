class AddForeignKeySignificantDateHistoriesToUsers < ActiveRecord::Migration[7.1]
  def up
    # Add foreign key constraint with NO ACTION to prevent deletion of users
    # when they have related significant_date_histories records
    execute <<-SQL
      ALTER TABLE significant_date_histories
      ADD CONSTRAINT fk_significant_date_histories_user_id
      FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE significant_date_histories
      DROP CONSTRAINT fk_significant_date_histories_user_id;
    SQL
  end
end

