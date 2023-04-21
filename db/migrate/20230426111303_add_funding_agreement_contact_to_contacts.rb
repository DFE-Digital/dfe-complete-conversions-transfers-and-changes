class AddFundingAgreementContactToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :funding_agreement_contact, :boolean, default: false
  end
end
