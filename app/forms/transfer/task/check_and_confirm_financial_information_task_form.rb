class Transfer::Task::CheckAndConfirmFinancialInformationTaskForm < BaseOptionalTaskForm
  attribute :academy_surplus_deficit, :string
  attribute :trust_surplus_deficit, :string

  def type_options
    [:surplus, :deficit]
  end
end
