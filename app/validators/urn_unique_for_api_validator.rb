class UrnUniqueForApiValidator < ActiveModel::Validator
  def validate(record)
    return unless record.urn.present?

    if record.is_a?(Api::Conversions::CreateProjectService)
      record.errors.add(:urn, :duplicate) if Conversion::Project.where(urn: record.urn, state: [:active, :inactive]).any?
    end

    if record.is_a?(Api::Transfers::CreateProjectService)
      record.errors.add(:urn, :duplicate) if Transfer::Project.where(urn: record.urn, state: [:active, :inactive]).any?
    end
  end
end
