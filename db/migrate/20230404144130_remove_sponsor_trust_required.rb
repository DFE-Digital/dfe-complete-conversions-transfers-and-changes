class RemoveSponsorTrustRequired < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :sponsor_trust_required, :boolean
  end
end
