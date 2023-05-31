class RemoveFundingAgreementContactColumnFromContacts < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :funding_agreement_contact, :boolean, default: false
  end
end
