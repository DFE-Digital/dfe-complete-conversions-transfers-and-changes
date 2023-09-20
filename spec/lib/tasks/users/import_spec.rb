require "rails_helper"

RSpec.describe "rake user_importer:import", type: :task do
  let(:csv_path) { "/csv/users.csv" }
  let(:mock_user_importer) { Import::UserCsvImporterService.new }

  subject { Rake::Task["users:import"] }

  before do
    allow(Import::UserCsvImporterService).to receive(:new).and_return(mock_user_importer)
    allow(mock_user_importer).to receive(:call).and_return(true)
  end

  after { subject.reenable }

  it "calls the #{Import::UserCsvImporterService} service with the supplied path" do
    ClimateControl.modify(CSV_PATH: csv_path) do
      subject.execute
    end

    expect(mock_user_importer).to have_received(:call).with(Pathname.new(csv_path)).once
  end

  it "errors if no path is supplied" do
    expect { subject.execute }
      .to raise_error(SystemExit, I18n.t("tasks.user_importer.import.error"))
  end
end
