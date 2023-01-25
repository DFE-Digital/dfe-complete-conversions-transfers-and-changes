require "rails_helper"

RSpec.describe "Voluntary task generator", type: :generator do
  before(:all) do
    system "bin/rails generate conversion_voluntary_task DummyTask"
  end

  after(:all) do
    # Clean up the generated files
    dummy_migration = Dir["db/migrate/*"].find { |name| name =~ /\d{14}_add_voluntary_dummy_task_task.rb/ }
    system "rm #{dummy_migration} app/models/conversion/voluntary/tasks/dummy_task.rb config/locales/task_lists/conversion/voluntary/dummy_task.en.yml app/views/conversion/voluntary/task_lists/tasks/dummy_task.html.erb"
  end

  let(:type) { "voluntary" }

  it_behaves_like "a conversion task generator"
end
