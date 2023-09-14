class AddUkprnIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :projects, :incoming_trust_ukprn
    add_index :projects, :outgoing_trust_ukprn
  end
end
