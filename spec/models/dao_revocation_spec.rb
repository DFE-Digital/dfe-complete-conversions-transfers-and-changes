require "rails_helper"

RSpec.describe DaoRevocation do
  describe "Attributes" do
    it { is_expected.to have_db_column(:date_of_decision).of_type :date }
    it { is_expected.to have_db_column(:decision_makers_name).of_type :string }
    it { is_expected.to have_db_column(:reason_school_closed).of_type :boolean }
    it { is_expected.to have_db_column(:reason_school_rating_improved).of_type :boolean }
    it { is_expected.to have_db_column(:reason_safeguarding_addressed).of_type :boolean }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:date_of_decision) }
    it { is_expected.to validate_presence_of(:decision_makers_name) }

    describe "#at_least_one_reason" do
      it "validates that at least one reason is checked" do
        project = build(:conversion_project, directive_academy_order: true)
        decision = described_class.new(date_of_decision: Date.today, decision_makers_name: "Bob Smith", project: project)
        expect(decision.valid?).to be false
        expect(decision.errors[:base]).to include("You must select at least one reason")

        decision = described_class.new(date_of_decision: Date.today, decision_makers_name: "Bob Smith", project: project, reason_school_closed: true)
        expect(decision.valid?).to be true
      end
    end

    describe "#conversion_project_with_dao" do
      it "is invalid if it is associated with a transfer project" do
        project = build(:transfer_project)
        decision = described_class.new(date_of_decision: Date.today, decision_makers_name: "Bob Smith", project: project)
        expect(decision.valid?).to be false
        expect(decision.errors[:base]).to include("A DAO revoked decision can only be recorded against a Conversion project with a Directive academy order")
      end

      it "is invalid if it is associated with a voluntary conversion" do
        project = build(:conversion_project, directive_academy_order: false)
        decision = described_class.new(date_of_decision: Date.today, decision_makers_name: "Bob Smith", project: project)
        expect(decision.valid?).to be false
        expect(decision.errors[:base]).to include("A DAO revoked decision can only be recorded against a Conversion project with a Directive academy order")
      end
    end
  end

  describe "Associations" do
    it { is_expected.to belong_to(:project) }
  end

  describe "Callbacks" do
    it "updates the state of the associated project after destruction" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project, directive_academy_order: true, state: :dao_revoked)
      decision = described_class.new(date_of_decision: Date.today, decision_makers_name: "Bob Smith", reason_school_closed: true, project: project)

      decision.destroy!
      expect(project.state).to eq("active")
    end
  end
end
