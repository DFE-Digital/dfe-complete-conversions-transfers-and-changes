class Conversion::Involuntary::Tasks::Subleases < TaskList::OptionalTask
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed, :boolean
  attribute :saved, :boolean

  attribute :email_signed, :boolean
  attribute :receive_signed, :boolean
  attribute :save_signed, :boolean

  private def not_applicable_only_key
    :actions
  end

  private def not_applicable_only_message
    I18n.t("errors.conversion_involuntary_tasks_subleases.actions.invalid")
  end
end
