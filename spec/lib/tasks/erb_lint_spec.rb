require "rails_helper"
require "erb_lint/cli"

RSpec.describe "ERB Lint tasks", type: :task do
  describe "erb_lint" do
    it "runs the ERB Lint cli with the correct arguments" do
      erb_linter = double(ERBLint::CLI)
      allow(ERBLint::CLI).to receive(:new).and_return(erb_linter)
      expect(erb_linter).to receive(:run).with(["--lint-all"])

      Rake::Task["erb_lint"].execute
    end
  end

  describe "erb_lint:fix" do
    it "runs the ERB Lint cli with the correct arguments" do
      erb_linter = double(ERBLint::CLI)
      allow(ERBLint::CLI).to receive(:new).and_return(erb_linter)
      expect(erb_linter).to receive(:run).with(["--lint-all", "-a"])

      Rake::Task["erb_lint:fix"].execute
    end
  end
end
