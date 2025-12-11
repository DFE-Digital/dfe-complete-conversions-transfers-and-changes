class AddForeignKeySignificantDateHistoriesToUsers < ActiveRecord::Migration[7.1]
  def up
    # Delete orphaned records where user_id references non-existent users
    # This must be done before adding the foreign key constraint
    execute <<-SQL
      DELETE FROM significant_date_histories
      WHERE NOT EXISTS (
        SELECT 1 
        FROM users u 
        WHERE u.id = significant_date_histories.user_id
      );
    SQL

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

