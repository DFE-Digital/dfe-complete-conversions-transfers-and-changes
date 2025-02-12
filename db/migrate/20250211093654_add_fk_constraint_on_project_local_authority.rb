class AddFkConstraintOnProjectLocalAuthority < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :projects, :local_authorities
  end
end
