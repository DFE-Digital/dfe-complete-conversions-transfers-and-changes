require "rails_helper"

RSpec.describe Export::CsvExportService do
  describe "#call" do
    it "raises an error" do
      expect { described_class.new.call }.to raise_error(NotImplementedError)
    end
  end
end
