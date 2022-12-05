class MoveIncomingTrustUkprnToConversionDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_details, :incoming_trust_ukprn, :integer

    remove_column :projects, :incoming_trust_ukprn, :integer
  end
end
