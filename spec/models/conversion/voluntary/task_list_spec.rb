require "rails_helper"

RSpec.describe Conversion::Voluntary::TaskList do
  let(:task_class) { Conversion::Voluntary::Tasks::Handover }
  let(:task_list) {
    Conversion::Voluntary::TaskList.create!(
      handover_review: true
    )
  }

  it_behaves_like "a task list"
end
