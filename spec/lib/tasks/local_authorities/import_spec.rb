require "rails_helper"

RSpec.describe "rake local_authorities:import", type: :task do
  subject { Rake::Task["local_authorities:import"] }

  let(:csv_path) { "/csv/local_authorities.csv" }

  before do
    allow_any_instance_of(Import::LocalAuthorityCsvImporterService).to receive(:call)
  end

  it "calls LocalAuthorityImporter service with the supplied path" do
    expect_any_instance_of(Import::LocalAuthorityCsvImporterService).to receive(:call).with(Pathname.new(csv_path)).once

    subject.invoke(csv_path)
  end

  it "errors if no path is supplied" do
    expect { subject.execute }
      .to raise_error(SystemExit, I18n.t("tasks.local_authority_importer.import.error"))
  end
end
