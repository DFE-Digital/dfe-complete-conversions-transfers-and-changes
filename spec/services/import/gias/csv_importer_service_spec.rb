require "rails_helper"

RSpec.describe Import::Gias::CsvImporterService do
  describe "initialize" do
    it "raises a NotImplementedError" do
      expect { described_class.new }.to raise_error(NotImplementedError)
    end
  end
end
