class SignificantDateHistoryReason < ApplicationRecord
  belongs_to :significant_date_history
  has_one :note, as: :notable, dependent: :destroy

  validates :reason_type, presence: true

  enum :reason_type, {
    legacy_reason: "legacy_reason",
    stakeholder_kick_off: "stakeholder_kick_off",
    progressing_faster_than_expected: "progressing_faster_than_expected",
    correcting_an_error: "correcting_an_error",
    incoming_trust: "incoming_trust",
    outgoing_trust: "outgoing_trust",
    academy: "academy",
    school: "school",
    local_authority: "local_authority",
    diocese: "diocese",
    tupe: "tupe",
    pensions: "pensions",
    union: "union",
    negative_press: "negative_press",
    governance: "governance",
    finance: "finance",
    viability: "viability",
    land: "land",
    buildings: "buildings",
    legal_documents: "legal_documents",
    commercial_transfer_agreement: "commercial_transfer_agreement",
    advisory_board_conditions: "advisory_board_conditions",
    voluntary_deferral: "voluntary_deferral"
  }
end
