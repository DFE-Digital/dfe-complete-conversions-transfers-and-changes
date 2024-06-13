class Conversion::Task::StakeholderKickOffTaskForm < ::BaseTaskForm
  include ActiveRecord::AttributeAssignment
  attribute :introductory_emails, :boolean
  attribute :local_authority_proforma, :boolean
  attribute :setup_meeting, :boolean
  attribute :meeting, :boolean
  attribute :check_provisional_conversion_date, :boolean
  attribute :confirmed_conversion_date, :date

  def initialize(tasks_data, user)
    @date_param_errors = ActiveModel::Errors.new(self)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    super(@tasks_data, @user)
  end

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:confirmed_conversion_date, attributes, without_day: true).invalid?
      @date_param_errors.add(:confirmed_conversion_date, :invalid)

      attributes.delete("confirmed_conversion_date(3i)")
      attributes.delete("confirmed_conversion_date(2i)")
      attributes.delete("confirmed_conversion_date(1i)")
    end

    super
  end

  def valid?(context = nil)
    super
    errors.merge!(@date_param_errors)
    errors.empty?
  end

  def save
    if @project.conversion_date_provisional? && confirmed_conversion_date.present?
      ::SignificantDateCreatorService.new(
        project: @project,
        revised_date: confirmed_conversion_date,
        user: @user,
        reasons: stakeholder_kick_off_reason
      ).update!
    end

    @tasks_data.assign_attributes(
      stakeholder_kick_off_introductory_emails: introductory_emails,
      stakeholder_kick_off_local_authority_proforma: local_authority_proforma,
      stakeholder_kick_off_setup_meeting: setup_meeting,
      stakeholder_kick_off_meeting: meeting,
      stakeholder_kick_off_check_provisional_conversion_date: check_provisional_conversion_date
    )
    @tasks_data.save!
  end

  def completed?
    attributes.except("confirmed_conversion_date").values.all?(&:present?) && @project.conversion_date_provisional? == false
  end

  def in_progress?
    attributes.values.any?(&:present?) || @project.conversion_date_provisional? == false
  end

  private def stakeholder_kick_off_reason
    [{type: :stakeholder_kick_off, note_text: "Conversion date confirmed as part of the External stakeholder kick off task."}]
  end
end
