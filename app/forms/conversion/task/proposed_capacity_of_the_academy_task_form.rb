class Conversion::Task::ProposedCapacityOfTheAcademyTaskForm < BaseOptionalTaskForm
  attribute :reception_to_six_years, :string
  attribute :seven_to_eleven_years, :string
  attribute :twelve_or_above_years, :string

  validates :reception_to_six_years, presence: true, numericality: {only_integer: true}, unless: :not_applicable?
  validates :seven_to_eleven_years, presence: true, numericality: {only_integer: true}, unless: :not_applicable?
  validates :twelve_or_above_years, presence: true, numericality: {only_integer: true}, unless: :not_applicable?
end
