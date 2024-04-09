class OutgoingIncomingTrustsUkprnValidator < ActiveModel::Validator
  def validate(record)
    return if record.outgoing_trust_ukprn.blank? || record.incoming_trust_ukprn.blank?

    if record.outgoing_trust_ukprn.eql?(record.incoming_trust_ukprn)
      record.errors.add(:outgoing_trust_ukprn, :matching)
      record.errors.add(:incoming_trust_ukprn, :matching)
    end
  end
end
