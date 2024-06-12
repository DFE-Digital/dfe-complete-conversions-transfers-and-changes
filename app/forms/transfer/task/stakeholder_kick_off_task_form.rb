class Transfer::Task::StakeholderKickOffTaskForm < BaseTaskForm
  include ActiveRecord::AttributeAssignment

  attribute :introductory_emails, :boolean
  attribute :setup_meeting, :boolean
  attribute :meeting, :boolean
  attribute :confirmed_transfer_date, :date

  def initialize(tasks_data, user)
    @date_param_errors = ActiveModel::Errors.new(self)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    super(@tasks_data, @user)
  end

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:confirmed_transfer_date, attributes, without_day: true).invalid?
      @date_param_errors.add(:confirmed_transfer_date, :invalid)

      attributes.delete("confirmed_transfer_date(3i)")
      attributes.delete("confirmed_transfer_date(2i)")
      attributes.delete("confirmed_transfer_date(1i)")
    end

    super
  end

  def valid?(context = nil)
    super
    errors.merge!(@date_param_errors)
    errors.empty?
  end

  def save
    if @project.transfer_date_provisional? && confirmed_transfer_date.present?
      SignificantDateCreatorService.new(
        project: @project,
        revised_date: confirmed_transfer_date,
        note_body: "Transfer date confirmed as part of the External stakeholder kick off task.",
        user: @user
      ).update!
    end

    @tasks_data.assign_attributes(
      stakeholder_kick_off_introductory_emails: introductory_emails,
      stakeholder_kick_off_setup_meeting: setup_meeting,
      stakeholder_kick_off_meeting: meeting
    )

    @tasks_data.save!
  end

  def completed?
    attributes.except("confirmed_transfer_date").values.all?(&:present?) && @project.transfer_date_provisional? == false
  end

  def in_progress?
    attributes.values.any?(&:present?) || @project.transfer_date_provisional? == false
  end
end
