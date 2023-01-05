require "rails_helper"

RSpec.describe Conversion::Involuntary::Tasks::Subleases, type: :model do
  describe "Validations" do
    subject { described_class.new }

    before { subject.assign_attributes(not_applicable:, received:, cleared:) }

    describe "not_applicable_only" do
      context "when `not_applicable` and any other actions are selected" do
        let(:not_applicable) { true }
        let(:received) { true }
        let(:cleared) { false }

        it "adds an error to the actions key" do
          expect(subject.valid?).to be false
          expect(subject.errors[:actions]).to include(I18n.t("errors.conversion_involuntary_tasks_subleases.actions.invalid"))
        end
      end
    end
  end
end
