class BaseOptionalTaskForm < BaseTaskForm
  before_save :unset_attributes_when_not_applicable

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

  private def unset_attributes_when_not_applicable
    if not_applicable?
      assign_attributes(
        actions_when_applicable.transform_values { nil }
      )
    end
  end
end
