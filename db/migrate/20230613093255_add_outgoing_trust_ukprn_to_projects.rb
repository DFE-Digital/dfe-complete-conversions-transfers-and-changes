class AddOutgoingTrustUkprnToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :outgoing_trust_ukprn, :integer
  end
end
