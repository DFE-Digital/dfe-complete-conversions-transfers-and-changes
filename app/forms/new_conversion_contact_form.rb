class NewConversionContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :contact_type, :string

  def initialize(attrs = {})
    super
    self.contact_type = "other"
  end

  def contact_types = %w[
    headteacher
    incoming_trust_ceo
    chair_of_governors
    other
  ]
end
