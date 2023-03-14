require "rails_helper"

RSpec.describe ProjectConversionDateMigrator do
  before do
    mock_successful_api_calls(establishment: any_args, trust: any_args)
  end

  describe "#migrate_up!" do
    context "when the project is provisional" do
      it "sets the conversion date to the provisional date" do
        user = create(:user)
        project = create(:conversion_project, provisional_conversion_date: Date.today.at_beginning_of_month)
        project.conversion_date = nil
        project.save(validate: false)

        project.task_list.user = user
        project.task_list.stakeholder_kick_off_confirmed_conversion_date = nil
        project.task_list.save

        described_class.new(project).migrate_up!
        project.reload

        expect(project.conversion_date).to eql project.provisional_conversion_date
        expect(project.conversion_date_provisional?).to eql true
      end
    end

    context "when the project is already confirmed" do
      context "and the project is assigned to a user" do
        it "creates a conversion date history for the user" do
          user = create(:user)
          project = create(
            :conversion_project,
            assigned_to: user,
            provisional_conversion_date: Date.today.at_beginning_of_month,
            conversion_date: Date.today.at_beginning_of_month + 1.month
          )

          described_class.new(project).migrate_up!
          project.reload

          expect(project.conversion_dates.count).to eql 1
          conversion_date_history = project.conversion_dates.order(:created_at).first

          expect(conversion_date_history.revised_date).to eql project.conversion_date
          expect(conversion_date_history.previous_date).to eql project.provisional_conversion_date

          expect(project.conversion_date_provisional?).to eql false
        end
      end

      context "and the project is not assigned to a user" do
        it "creates a conversion date history for the regional delivery officer" do
          user = create(:user, :regional_delivery_officer)
          project = create(
            :conversion_project,
            assigned_to: nil,
            regional_delivery_officer: user,
            provisional_conversion_date: Date.today
          )

          described_class.new(project).migrate_up!
          project.reload

          expect(project.conversion_dates.count).to eql 1
          conversion_date_history = project.conversion_dates.last

          expect(conversion_date_history.revised_date).to eql project.conversion_date
          expect(conversion_date_history.previous_date).to eql project.provisional_conversion_date

          expect(project.conversion_date_provisional?).to eql false
        end
      end
    end
  end
end
