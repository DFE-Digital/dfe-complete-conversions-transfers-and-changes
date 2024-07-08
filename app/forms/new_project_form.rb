class NewProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :project_type, :string

  def initialize(attrs = {})
    super
    self.project_type = "conversion"
  end

  def project_types = %w[
    conversion
    transfer
    form_a_mat_conversion
    form_a_mat_transfer
  ]
end
