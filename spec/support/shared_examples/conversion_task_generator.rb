require "rails_helper"

RSpec.shared_examples "a conversion task generator" do
  it "creates a migration file for the new Task" do
    dummy_migration_file_name = Dir["db/migrate/*"].find { |name| name =~ /\d{14}_add_#{type}_dummy_task_task.rb/ }
    dummy_migration = File.open(dummy_migration_file_name)
    example_migration = File.open("spec/fixtures/generators/#{type}/add_#{type}_dummy_task_task.rb")
    diff = Diffy::Diff.new(dummy_migration.read, example_migration.read).to_s
    expect(diff).to be_empty
  end

  it "creates a translation file for the new Task" do
    dummy_translation = File.open("config/locales/task_lists/conversion/#{type}/dummy_task.en.yml")
    example_translation = File.open("spec/fixtures/generators/#{type}/dummy_task.en.yml")
    diff = Diffy::Diff.new(File.read(dummy_translation), example_translation.read).to_s
    expect(diff).to be_empty
  end

  it "creates a model file for the new Task" do
    dummy_model = File.open("app/models/conversion/#{type}/tasks/dummy_task.rb")
    example_model = File.open("spec/fixtures/generators/#{type}/dummy_task.rb")
    diff = Diffy::Diff.new(File.read(dummy_model), example_model.read).to_s
    expect(diff).to be_empty
  end

  it "creates a view file for the new Task" do
    dummy_view = File.open("app/views/conversion/#{type}/task_lists/tasks/dummy_task.html.erb")
    example_view = File.open("spec/fixtures/generators/#{type}/dummy_task.html.erb")
    diff = Diffy::Diff.new(File.read(dummy_view), example_view.read).to_s
    expect(diff).to be_empty
  end
end
