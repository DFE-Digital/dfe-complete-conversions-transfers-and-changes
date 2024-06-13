require "rails_helper"

RSpec.describe SignificantDateReasonsDataMigration do
  let(:user) { create(:user) }

  before do
    mock_all_academies_api_responses
  end

  it "adds a SignificantDateReason for every SignificantDate a project has" do
    conversion_without_history = create_project_helper(:conversion, 0)
    conversion_with_single_history = create_project_helper(:conversion, 1)
    conversion_with_multiple_history = create_project_helper(:conversion, 3)

    transfer_without_history = create_project_helper(:transfer, 0)
    transfer_with_single_history = create_project_helper(:transfer, 1)
    transfer_with_multiple_history = create_project_helper(:transfer, 3)

    described_class.new.migrate!

    expect(conversion_without_history.date_history.count).to be_zero

    date_history = conversion_with_single_history.date_history.order(:created_at)

    expect(date_history.first.reasons.count).to be 1
    expect(date_history.first.reasons.first.note.body).to eql "Note for date history reason number 1"

    date_history = conversion_with_multiple_history.date_history.order(:created_at)

    expect(date_history.first.reasons.count).to be 1
    expect(date_history.first.reasons.first.note.body).to eql "Note for date history reason number 1"

    expect(date_history.last.reasons.count).to be 1
    expect(date_history.last.reasons.first.note.body).to eql "Note for date history reason number 3"

    expect(transfer_without_history.date_history.count).to be_zero

    date_history = transfer_with_single_history.date_history.order(:created_at)

    expect(date_history.first.reasons.count).to be 1
    expect(date_history.first.reasons.first.note.body).to eql "Note for date history reason number 1"

    date_history = transfer_with_multiple_history.date_history.order(:created_at)

    expect(date_history.first.reasons.count).to be 1
    expect(date_history.first.reasons.first.note.body).to eql "Note for date history reason number 1"

    expect(date_history.last.reasons.count).to be 1
    expect(date_history.last.reasons.first.note.body).to eql "Note for date history reason number 3"
  end

  it "assigns the two different reason types correctly" do
    conversion_project = create_project_helper(:conversion, 1)
    conversion_project_with_stakeholder_kick_off = create_project_with_stakeholder_kick_off(:conversion)

    transfer_project = create_project_helper(:conversion, 1)
    transfer_project_with_stakeholder_kick_off = create_project_with_stakeholder_kick_off(:conversion)

    described_class.new.migrate!

    expect(conversion_project_with_stakeholder_kick_off.date_history.first.reasons.first.reason_type).to eql "stakeholder_kick_off"
    expect(conversion_project.date_history.first.reasons.first.reason_type).to eql "legacy_reason"
    expect(transfer_project_with_stakeholder_kick_off.date_history.first.reasons.first.reason_type).to eql "stakeholder_kick_off"
    expect(transfer_project.date_history.first.reasons.first.reason_type).to eql "legacy_reason"
  end

  it "skips any history that already has a reason, i.e. will not create duplicates" do
    create_project_helper(:conversion, 3)
    create_project_helper(:transfer, 3)

    allow(SignificantDateHistoryReason).to receive(:create!).and_call_original

    described_class.new.migrate!

    described_class.new.migrate!

    expect(SignificantDateHistoryReason).to have_received(:create!).exactly(6).times
  end

  def create_project_helper(project_type, history_count = 0)
    case project_type
    when :conversion
      project = create(:conversion_project)
    when :transfer
      project = create(:transfer_project)
    else
      raise ArgumentError.new("Supply a project type!")
    end

    history_count.times do |index|
      note = Note.create!(user:, body: "Note for date history reason number #{index + 1}", project: project)

      SignificantDateHistory.create!(
        user: user,
        previous_date: Date.today.at_beginning_of_month,
        revised_date: Date.today.at_beginning_of_month + index.month,
        created_at: Date.today + index.days,
        project: project,
        note: note
      )
    end

    project
  end

  def create_project_with_stakeholder_kick_off(project_type)
    case project_type
    when :conversion
      project = create(:conversion_project)
      note_body = "Transfer date confirmed as part of the External stakeholder kick off task."
    when :transfer
      project = create(:transfer_project)
      note_body = "Conversion date confirmed as part of the External stakeholder kick off task."
    else
      raise ArgumentError.new("Supply a project type!")
    end

    note = Note.create!(user:, body: note_body, project: project)

    SignificantDateHistory.create!(
      user: user,
      previous_date: Date.today.at_beginning_of_month,
      revised_date: Date.today.at_beginning_of_month + 1.month,
      created_at: Date.today,
      project: project,
      note: note
    )

    project
  end
end
