class DateHistory::Reasons::NewLaterForm < DateHistory::Reasons::BaseForm
  CONVERSION_REASONS_LIST = %i[
    incoming_trust
    school
    local_authority
    diocese
    tupe
    pensions
    union
    negative_press
    governance
    finance
    viability
    land
    buildings
    legal_documents
    correcting_an_error
    voluntary_deferral
    advisory_board_conditions
  ]

  TRANSFER_REASONS_LIST = %i[
    incoming_trust
    outgoing_trust
    academy
    local_authority
    diocese
    tupe
    pensions
    union
    negative_press
    governance
    finance
    viability
    land
    buildings
    legal_documents
    commercial_transfer_agreement
    correcting_an_error
    voluntary_deferral
    advisory_board_conditions
  ]

  ALL_REASONS_LIST = (TRANSFER_REASONS_LIST + CONVERSION_REASONS_LIST).uniq

  ALL_REASONS_LIST.each do |reason|
    attribute reason, :boolean
    attribute :"#{reason}_note", :string
    validates :"#{reason}_note", presence: {message: I18n.t("errors.attributes.base.blank")}, if: -> { reason_selected?(reason) }
  end

  def reasons_list
    case project.class.name
    when "Conversion::Project"
      CONVERSION_REASONS_LIST
    when "Transfer::Project"
      TRANSFER_REASONS_LIST
    else
      raise StandardError.new("Unknown project type or nil project.")
    end
  end
end
