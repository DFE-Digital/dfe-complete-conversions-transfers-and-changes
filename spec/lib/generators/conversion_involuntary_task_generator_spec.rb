require "rails_helper"

RSpec.describe "Involuntary task generator", type: :generator do
  before(:all) do
    system "bin/rails generate conversion_involuntary_task DummyTask"
  end

  after(:all) do
    # Clean up the generated files
    dummy_migration = Dir["db/migrate/*"].find { |name| name =~ /\d{14}_add_involuntary_dummy_task_task.rb/ }
    system "rm #{dummy_migration} app/models/conversion/involuntary/tasks/dummy_task.rb config/locales/task_lists/conversion/involuntary/dummy_task.en.yml app/views/conversion/involuntary/task_lists/tasks/dummy_task.html.erb"
  end

  let(:type) { "involuntary" }

  it_behaves_like "a conversion task generator"
end
