class TaskList::OptionalTask < TaskList::Task
  attribute :not_applicable, :boolean

  validate :not_applicable_only

  private def not_applicable?
    not_applicable
  end

  private def completed?
    actions_when_applicable.values.all?(&:present?)
  end

  private def actions_when_applicable
    attributes.except("not_applicable")
  end

  private def not_applicable_only
    if actions_when_applicable.values.any?(&:present?) && not_applicable
      errors.add(not_applicable_only_key, not_applicable_only_message)
    end
  end
end
