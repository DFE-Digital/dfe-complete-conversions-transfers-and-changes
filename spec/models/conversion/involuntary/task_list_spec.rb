require "rails_helper"

RSpec.describe Conversion::Involuntary::TaskList do
  let(:task_class) { Conversion::Involuntary::Tasks::Handover }
  let(:task_list) {
    Conversion::Involuntary::TaskList.create!(
      handover_review: true
    )
  }

  it_behaves_like "a task list"
end
