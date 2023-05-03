require "rails_helper"

RSpec.describe "conversion tasks generator" do
  before(:all) do
    system "bin/rails generate conversion:task Fake"
  end

  after(:all) do
    system "rm #{migration_file_path}"
    system "rm app/forms/conversion/task/fake_task_form.rb"
    system "rm -dR app/views/conversions/tasks/fake/"
    system "rm config/locales/conversion/tasks/fake.en.yml"
  end

  describe "the migration" do
    it "creates the correct migration file" do
      migration = File.read(migration_file_path)

      expect(migration).to include "Fake"
      expect(migration).to include "change"
    end
  end

  describe "the form object" do
    it "creates the correct file and updates it" do
      form_file = File.read("app/forms/conversion/task/fake_task_form.rb")

      expect(form_file).to include "FakeTaskForm"
      expect(form_file).not_to include "TaskName"
    end
  end

  describe "the view" do
    it "creates the correct view file" do
      expect(File.exist?("app/views/conversions/tasks/fake/edit.html.erb")).to eq true
    end
  end

  describe "the locale" do
    it "creates the correct locales file and updates it" do
      locale_file = File.read("config/locales/conversion/tasks/fake.en.yml")

      expect(locale_file).to include "fake:"
      expect(locale_file).not_to include "task_name:"
    end
  end

  def migration_file_path
    Dir["db/migrate/*"].find { |name| name =~ /\d{14}_add_conversion_fake_task_attributes.rb/ }
  end
end
