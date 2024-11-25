class Transfer::Task::BankDetailsChangingTaskForm < BaseTaskForm
  attribute :yes_no, :boolean

  private def completed?
    !attributes["yes_no"].nil?
  end
end
