class CookiesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :accept_optional_cookies, :boolean

  def responses
    [OpenStruct.new(id: true, name: "Yes"), OpenStruct.new(id: false, name: "No")]
  end
end
