class DaoRevocationSteppedForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  STEPS = %i[
    confirm
    reasons
    minister
    date
  ]

  attribute :reason_school_closed, :boolean
  attribute :reason_school_closed_note, :string
  attribute :reason_school_rating_improved, :boolean
  attribute :reason_school_rating_improved_note, :string
  attribute :reason_safeguarding_addressed, :boolean
  attribute :reason_safeguarding_addressed_note, :string
  attribute :reason_change_to_policy, :boolean
  attribute :reason_change_to_policy_note, :string
  attribute :minister_name, :string
  attribute :date_of_decision, :date

  attribute :confirm_minister_approved, :boolean
  attribute :confirm_letter_sent, :boolean
  attribute :confirm_letter_saved, :boolean

  validate :at_least_one_reason, on: :reasons
  validates :reason_school_closed_note,
    presence: {message: I18n.t("errors.attributes.base.blank")},
    if: -> { reason_school_closed.present? },
    on: :reasons
  validates :reason_school_rating_improved_note,
    presence: {message: I18n.t("errors.attributes.base.blank")},
    if: -> { reason_school_rating_improved.present? },
    on: :reasons
  validates :reason_safeguarding_addressed_note,
    presence: {message: I18n.t("errors.attributes.base.blank")},
    if: -> { reason_safeguarding_addressed.present? },
    on: :reasons
  validates :reason_change_to_policy_note,
    presence: {message: I18n.t("errors.attributes.base.blank")},
    if: -> { reason_change_to_policy.present? },
    on: :reasons

  validates :minister_name, presence: true, on: :minister
  validates :date_of_decision, presence: true, on: :date
  validate :all_confirmed, on: :confirm

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:date_of_decision, attributes).invalid?
      attributes.delete("date_of_decision(3i)")
      attributes.delete("date_of_decision(2i)")
      attributes.delete("date_of_decision(1i)")
      self.date_of_decision = nil
    end

    super
  end

  def self.first_step
    STEPS.first
  end

  def self.last_step
    STEPS.last
  end

  def self.steps
    STEPS
  end

  def reasons
    reasons = []

    reasons << :reason_school_closed if reason_school_closed
    reasons << :reason_school_rating_improved if reason_school_rating_improved
    reasons << :reason_safeguarding_addressed if reason_safeguarding_addressed
    reasons << :reason_change_to_policy if reason_change_to_policy

    reasons
  end

  def reasons_empty?
    reasons.filter_map { |reason| reason }.empty?
  end

  def checkable?
    (reason_school_closed.present? || reason_school_rating_improved.present? || reason_safeguarding_addressed.present? || reason_change_to_policy.present?) &&
      minister_name.present? && date_of_decision.present?
  end

  def to_h
    {
      reason_school_closed: reason_school_closed.to_s,
      reason_school_rating_improved: reason_school_rating_improved.to_s,
      reason_safeguarding_addressed: reason_safeguarding_addressed.to_s,
      reason_change_to_policy: reason_change_to_policy.to_s,
      reason_school_closed_note: reason_school_closed_note.to_s,
      reason_school_rating_improved_note: reason_school_rating_improved_note.to_s,
      reason_safeguarding_addressed_note: reason_safeguarding_addressed_note.to_s,
      reason_change_to_policy_note: reason_change_to_policy_note.to_s,
      minister_name: minister_name,
      date_of_decision: date_of_decision.to_s
    }
  end

  def save(project, user)
    revocation = DaoRevocation.create(
      project_id: project.id,
      decision_makers_name: minister_name,
      date_of_decision: date_of_decision
    )

    if revocation.persisted?
      reasons.each do |reason|
        note = Note.create!(project: project, user: user, body: public_send(:"#{reason}_note"))
        DaoRevocationReason.create!(dao_revocation: revocation, reason_type: reason, note: note)
      end

      project.update!(state: :dao_revoked)
      true
    else
      errors.add(:base, :check_answers)
      false
    end
  end

  private def at_least_one_reason
    selected_reasons = reasons.filter_map { |reason| reason }

    errors.add(:reasons, :at_least_one_reason) if selected_reasons.empty?
  end

  private def all_confirmed
    errors.add(:base, :all_confirmed) unless confirm_minister_approved && confirm_letter_sent && confirm_letter_saved
  end
end
