class DateHistory::Reasons::NewEarlierForm < DateHistory::Reasons::BaseForm
  REASONS_LIST = %i[
    progressing_faster_than_expected
    correcting_an_error
  ]

  REASONS_LIST.each do |reason|
    attribute reason, :boolean
    attribute :"#{reason}_note", :string
  end

  validates :progressing_faster_than_expected_note, presence: {message: I18n.t("errors.attributes.base.blank")}, if: -> { progressing_faster_than_expected.present? }
  validates :correcting_an_error_note, presence: {message: I18n.t("errors.attributes.base.blank")}, if: -> { correcting_an_error.present? }

  def reasons_list
    REASONS_LIST
  end
end
