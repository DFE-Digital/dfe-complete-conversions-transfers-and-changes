class Project < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :contacts, dependent: :destroy

  validates :urn, presence: true, numericality: {only_integer: true}, length: {is: 6}
  validates :trust_ukprn, presence: true, numericality: {only_integer: true}
  validates :target_completion_date, presence: true
  validates :team_leader, presence: true
  validates :regional_delivery_officer_id, presence: true, allow_blank: false

  validate :first_day_of_month, :trust_ukprn_is_correct_format
  validate :target_completion_date_is_in_the_future, on: :create
  validate :establishment_exists, :trust_exists, on: :create

  belongs_to :caseworker, class_name: "User", optional: true
  belongs_to :team_leader, class_name: "User", optional: false
  belongs_to :regional_delivery_officer, class_name: "User", optional: true

  def establishment
    @establishment || retrieve_establishment
  end

  def trust
    @trust || retrieve_trust
  end

  private def establishment_exists
    retrieve_establishment
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end

  private def trust_exists
    retrieve_trust
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:trust_ukprn, :no_trust_found)
  end

  private def retrieve_establishment
    result = AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    @establishment = result.object
  end

  private def retrieve_trust
    result = AcademiesApi::Client.new.get_trust(trust_ukprn)
    raise result.error if result.error.present?

    @trust = result.object
  end

  private def first_day_of_month
    return if target_completion_date.nil?

    # Target completion date is always the 1st of the month.
    if target_completion_date.day != 1
      errors.add(:target_completion_date, :must_be_first_of_the_month)
    end
  end

  private def trust_ukprn_is_correct_format
    return if trust_ukprn.nil?

    number_of_digits = trust_ukprn.digits.count
    first_digit = trust_ukprn.to_s.first.to_i

    if number_of_digits != 8 || first_digit != 1
      errors.add(:trust_ukprn, :must_be_correct_format)
    end
  end

  private def target_completion_date_is_in_the_future
    return if target_completion_date.nil?

    unless target_completion_date.future?
      errors.add(:target_completion_date, :must_be_in_the_future)
    end
  end
end
