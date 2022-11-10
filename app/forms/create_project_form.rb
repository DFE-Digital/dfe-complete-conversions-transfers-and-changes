class CreateProjectForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  include ::MultiparameterDate

  attr_accessor :urn,
    :incoming_trust_ukprn,
    :establishment_sharepoint_link,
    :trust_sharepoint_link,
    :advisory_board_conditions,
    :note_body,
    :user,
    :attributes_with_empty_values,
    :attributes_with_invalid_values

  attr_reader :target_conversion_date,
    :advisory_board_date

  validates :urn,
    :incoming_trust_ukprn,
    :establishment_sharepoint_link,
    :trust_sharepoint_link, presence: true

  validates :urn, urn: true
  validates :incoming_trust_ukprn, ukprn: true

  validates :target_conversion_date, date_in_the_future: true
  validates :advisory_board_date, date_in_the_past: true

  validate :multiparameter_date_attributes_values
  validate :multiparameter_date_attributes_empty

  def initialize(params = {})
    @attributes_with_empty_values = []
    @attributes_with_invalid_values = []
    super(params)
  end

  def target_conversion_date=(value)
    if month_for(value).nil? && year_for(value).nil?
      @attributes_with_empty_values << :target_conversion_date
      return
    end

    if date_parameter_valid?(value)
      @target_conversion_date = date_from_multiparameter_hash(value)
    else
      @attributes_with_invalid_values << :target_conversion_date
    end
  end

  def advisory_board_date=(value)
    if value.nil? || (day_for(value).nil? && month_for(value).nil? && year_for(value).nil?)
      @attributes_with_empty_values << :advisory_board_date
      return
    end

    if date_parameter_valid?(value)
      @advisory_board_date = date_from_multiparameter_hash(value)
    else
      @attributes_with_invalid_values << :advisory_board_date
    end
  end

  def save
    if valid?
      true
    end
  end

  private def multiparameter_date_attributes_values
    return if @attributes_with_invalid_values.empty?
    @attributes_with_invalid_values.each { |attribute| errors.add(attribute, :invalid) }
  end

  private def multiparameter_date_attributes_empty
    return if @attributes_with_empty_values.empty?
    @attributes_with_empty_values.each { |attribute| errors.add(attribute, :blank) }
  end
end
