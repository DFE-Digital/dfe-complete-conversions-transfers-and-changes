class Projects::Conversions::Tasks::StakeholderKickOffTaskForm < Projects::Conversions::Tasks::OptionalTask
  attribute :local_authority_proforma
  attribute :introductory_emails
  attribute :setup_meeting
  attribute :meeting
  attribute :confirmed_conversion_date
  attribute :check_provisional_conversion_date
  attribute :title
  attribute :name
  attribute :email
  attribute :phone
  attribute "confirmed_conversion_date(3i)"
  attribute "confirmed_conversion_date(2i)"
  attribute "confirmed_conversion_date(1i)"
  attribute :academy_urn

  validate :conversion_date_format, if: -> { month.present? || year.present? }

  ATTRIBUTE_PREFIX = :stakeholder_kick_off

  def initialize(task_list)
    @task_list = task_list
    @project = task_list.project
    attributes = task_attributes
    attributes["academy_urn"] = @project.academy_urn
    attributes["confirmed_conversion_date"] = @project.conversion_date
    super(attributes)
  end

  def save
    @task_list.assign_attributes({
      stakeholder_kick_off_introductory_emails: introductory_emails,
      stakeholder_kick_off_local_authority_proforma: local_authority_proforma,
      stakeholder_kick_off_setup_meeting: setup_meeting,
      stakeholder_kick_off_check_provisional_conversion_date: check_provisional_conversion_date,
      stakeholder_kick_off_meeting: meeting
    })
    @task_list.save!

    @project.academy_urn = academy_urn
    @project.conversion_date = conversion_date unless conversion_date.nil?
    @project.save!
  end

  def completed?
    attributes.except("confirmed_conversion_date(3i)", "confirmed_conversion_date(2i)", "confirmed_conversion_date(1i)").values.all?(&:present?)
  end

  def attribute_prefix
    ATTRIBUTE_PREFIX
  end

  def conversion_date
    return nil if month.empty? || year.empty?

    Date.new(year.to_i, month.to_i, 1)
  end

  private def conversion_date_format
    return if month.blank? && year.blank?

    format_error = I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.confirmed_conversion_date.errors.format")

    errors.add(:confirmed_conversion_date, format_error) if month.blank? && year.present?
    errors.add(:confirmed_conversion_date, format_error) if month.present? && year.blank?
    errors.add(:confirmed_conversion_date, format_error) unless (1..12).cover?(month.to_i)
    errors.add(:confirmed_conversion_date, format_error) unless (2000..2500).cover?(year.to_i)
  end

  private def month
    attributes["confirmed_conversion_date(2i)"]
  end

  private def year
    attributes["confirmed_conversion_date(1i)"]
  end
end
