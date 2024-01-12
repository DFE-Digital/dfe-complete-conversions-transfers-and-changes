require "rails_helper"

RSpec.describe "rake project_data:grant_payment_certificate_dates", type: :task do
  subject { Rake::Task["project_data:grant_payment_certificate_dates"] }

  let(:csv_path) { "/csv/grant_payment_certificate_dates.csv" }

  before do
    allow_any_instance_of(Import::GrantCertificateDateImporterService).to receive(:call)
  end

  it "calls GrantCertificateDateImporterService service with the supplied path" do
    expect_any_instance_of(Import::GrantCertificateDateImporterService).to receive(:call).with(Pathname.new(csv_path)).once

    subject.invoke(csv_path)
  end

  it "errors if no path is supplied" do
    expect { subject.execute }
      .to raise_error(SystemExit, I18n.t("tasks.grant_payment_certificate_importer.import.error"))
  end
end
