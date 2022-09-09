require "rails_helper"
require "erb_lint/cli"

RSpec.describe "ERB Lint tasks", type: :task do
  describe "erblint" do
    it "runs the ERB Lint cli with the correct arguments" do
      erb_linter = double(ERBLint::CLI)
      allow(ERBLint::CLI).to receive(:new).and_return(erb_linter)
      expect(erb_linter).to receive(:run).with(["--lint-all"])

      Rake::Task["erblint"].execute
    end
  end

  describe "erblint:fix" do
    it "runs the ERB Lint cli with the correct arguments" do
      erb_linter = double(ERBLint::CLI)
      allow(ERBLint::CLI).to receive(:new).and_return(erb_linter)
      expect(erb_linter).to receive(:run).with(["--lint-all", "-a"])

      Rake::Task["erblint:fix"].execute
    end
  end
end
