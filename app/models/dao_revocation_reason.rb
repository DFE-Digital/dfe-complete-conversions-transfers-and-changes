class DaoRevocationReason < ApplicationRecord
  belongs_to :dao_revocation
  has_one :note, as: :notable, dependent: :destroy

  validates :note, presence: true
  validates :reason_type, presence: true

  enum :reason_type, {
    reason_school_closed: "school_closed",
    reason_school_rating_improved: "school_rating_improved",
    reason_safeguarding_addressed: "safeguarding_addressed",
    reason_change_to_policy: "change_to_policy"
  }
end
