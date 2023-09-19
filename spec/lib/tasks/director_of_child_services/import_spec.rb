require "rails_helper"

RSpec.describe "rake director_of_child_services:import", type: :task do
  subject { Rake::Task["director_of_child_services:import"] }

  let(:csv_path) { "/csv/dcs.csv" }

  before do
    allow_any_instance_of(Import::DirectorOfChildServicesCsvImporterService).to receive(:call)
  end

  it "calls DirectorOfChildServices service with the supplied path" do
    expect_any_instance_of(Import::DirectorOfChildServicesCsvImporterService).to receive(:call).with(Pathname.new(csv_path)).once

    subject.invoke(csv_path)
  end

  it "errors if no path is supplied" do
    expect { subject.execute }
      .to raise_error(SystemExit, I18n.t("tasks.director_of_child_services_importer.import.error"))
  end
end
