class Conversion::Task::ArticlesOfAssociationTaskForm < ::BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed, :boolean
  attribute :saved, :boolean
  attribute :sent, :boolean
end
