class Conversion::Voluntary::Tasks::StakeholderKickOff < TaskList::Task
  attribute :introductory_emails
  attribute :local_authority_proforma
  attribute :setup_meeting
  attribute :meeting
  attribute :conversion_checklist
  attribute :confirmed_conversion_date
  attribute "confirmed_conversion_date(3i)"
  attribute "confirmed_conversion_date(2i)"
  attribute "confirmed_conversion_date(1i)"

  def completed?
    attributes.except("confirmed_conversion_date(3i)", "confirmed_conversion_date(2i)", "confirmed_conversion_date(1i)").values.all?(&:present?)
  end
end
