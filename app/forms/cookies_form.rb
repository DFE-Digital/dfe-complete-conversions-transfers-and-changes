class CookiesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :accept_optional_cookies, :boolean

  RESPONSES = [OpenStruct.new(id: true, name: "Yes"), OpenStruct.new(id: false, name: "No")]

  def responses
    RESPONSES
  end
end
