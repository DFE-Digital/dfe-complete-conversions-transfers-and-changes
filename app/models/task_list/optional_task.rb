class TaskList::OptionalTask < TaskList::Task
  attribute :not_applicable, :boolean

  private def not_applicable?
    not_applicable
  end

  private def completed?
    actions_when_applicable.values.all?(&:present?)
  end

  private def actions_when_applicable
    attributes.except("not_applicable")
  end
end
