class GroupIdValidator < ActiveModel::Validator
  def validate(record)
    group_id = record.group_id

    return unless group_id.present?

    record.errors.add(:group_id, :invalid) unless group_id.match?(/\AGRP_\d{8}\z/)

    if record.incoming_trust_ukprn.present?
      group = ProjectGroup.find_by_group_identifier(group_id)
      record.errors.add(:group_id, :trust_ukprn) unless group.nil? || group.trust_ukprn.eql?(record.incoming_trust_ukprn)
    end
  end
end
