require "rails_helper"

RSpec.describe TaskList::OptionalTask, type: :model do
  let(:testing_model) { Conversion::Voluntary::OptionalTestingClass }
  let(:testing_model_instance) { testing_model.new }

  describe "#status" do
    subject { testing_model_instance.status }

    before { testing_model_instance.assign_attributes(not_applicable:, received:, cleared:) }

    context "when not applicable" do
      let(:not_applicable) { true }
      let(:received) { true }
      let(:cleared) { true }

      it { expect(subject).to be :not_applicable }
    end

    context "when all values except `not_applicable` are present" do
      let(:not_applicable) { false }
      let(:received) { true }
      let(:cleared) { true }

      it { expect(subject).to be :completed }
    end

    context "when some values are present" do
      let(:not_applicable) { false }
      let(:received) { true }
      let(:cleared) { false }

      it { expect(subject).to be :in_progress }
    end

    context "when no values are present" do
      let(:not_applicable) { false }
      let(:received) { false }
      let(:cleared) { false }

      it { expect(subject).to be :not_started }
    end
  end
end

class Conversion::Voluntary::OptionalTestingClass < TaskList::OptionalTask
  attribute :received, :boolean
  attribute :cleared, :boolean
end
