class Project < ApplicationRecord
  has_many :sections

  validates :urn, presence: true, numericality: {only_integer: true}

  belongs_to :delivery_officer, class_name: "User", optional: true

  def establishment
    @establishment ||= retrieve_establishment
  end

  private def retrieve_establishment
    result = AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    result.object
  end
end
