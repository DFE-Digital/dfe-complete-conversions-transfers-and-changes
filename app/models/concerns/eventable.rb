module Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events, dependent: :destroy, as: :eventable
  end
end
