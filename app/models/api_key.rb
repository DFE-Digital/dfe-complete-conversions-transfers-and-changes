class ApiKey < ApplicationRecord
  validates :api_key, presence: true
  validates :expires_at, presence: true

  def expired?
    Date.today > expires_at
  end
end
