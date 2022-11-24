module Projectable
  extend ActiveSupport::Concern

  included do
    has_one :project, as: :projectable, touch: true
  end
end
