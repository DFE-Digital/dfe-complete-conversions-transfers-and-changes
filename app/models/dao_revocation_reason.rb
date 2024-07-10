class DaoRevocationReason < ApplicationRecord
  belongs_to :dao_revocation
  has_one :note, as: :notable, dependent: :destroy

  validates :note, presence: true
  validates :reason_type, presence: true

  enum :reason_type, {
    school_closed: "school_closed",
    school_rating_improved: "school_rating_improved",
    safeguarding_addressed: "safeguarding_addressed"
  }
end
