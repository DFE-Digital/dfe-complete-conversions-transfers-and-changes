class Project < ApplicationRecord
  has_many :sections, dependent: :destroy

  validates :urn, presence: true, numericality: {only_integer: true}
  validate :establishment_exists, on: :create

  belongs_to :delivery_officer, class_name: "User", optional: true

  def establishment
    @establishment || retrieve_establishment
  end

  def conversion_project
    @conversion_project ||= retrieve_conversion_project
  end

  private def establishment_exists
    retrieve_establishment
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end

  private def retrieve_establishment
    result = AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    @establishment = result.object
  end

  private def retrieve_conversion_project
    result = AcademiesApi::Client.new.get_conversion_project(urn)
    raise result.error if result.error.present?

    result.object
  end
end
