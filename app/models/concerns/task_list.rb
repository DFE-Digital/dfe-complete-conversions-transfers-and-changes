module TaskList
  extend ActiveSupport::Concern

  included do
    has_one :project, as: :task_list, touch: true
  end
end
