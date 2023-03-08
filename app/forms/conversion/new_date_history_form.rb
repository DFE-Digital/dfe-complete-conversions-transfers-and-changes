class Conversion::NewDateHistoryForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  CONVERSION_DATE_DAY = 1

  attribute :project_id
  attribute :user_id
  attribute :note_body
  attribute :revised_date
  attribute "revised_date(3i)"
  attribute "revised_date(2i)"
  attribute "revised_date(1i)"

  validates :project_id, :user_id, :note_body, presence: true

  validate :revised_date_format

  def save
    return false unless valid?

    project = Project.find(project_id)
    previous_date = project.conversion_date
    revised_date = date_from_attributes

    ActiveRecord::Base.transaction do
      conversion_date_history_note = Note.create!(project_id: project_id, user_id: user_id, body: note_body)
      date_history = Conversion::DateHistory.create!(project_id: project_id, previous_date: previous_date, revised_date: revised_date, note: conversion_date_history_note)
      project.update!(conversion_date: revised_date)

      raise ActiveRecord::RecordInvalid unless conversion_date_history_note.persisted? && project.persisted? && date_history.persisted?
    rescue ActiveRecord::RecordInvalid
      errors.add(:revised_date, :transaction)
      return false
    end

    true
  end

  private def revised_date_format
    errors.add(:revised_date, :format) if month.blank? || year.blank?
    errors.add(:revised_date, :format) unless (1..12).cover?(month.to_i)
    errors.add(:revised_date, :format) unless (2000..2500).cover?(year.to_i)
  end

  private def day
    CONVERSION_DATE_DAY.to_i
  end

  private def month
    attributes["revised_date(2i)"].to_i
  end

  private def year
    attributes["revised_date(1i)"].to_i
  end

  private def date_from_attributes
    Date.new(year, month, day)
  end
end
