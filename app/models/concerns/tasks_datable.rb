module TasksDatable
  extend ActiveSupport::Concern

  included do
    has_one :project, as: :tasks_data, touch: true
  end
end
