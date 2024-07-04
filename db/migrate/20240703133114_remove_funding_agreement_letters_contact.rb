class RemoveFundingAgreementLettersContact < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :funding_agreement_contact_id, :uuid
  end
end
