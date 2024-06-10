# Data Migration service
# This service is designed to be used once to create SignificantDateHistoryReasons for all projects
#
# Usage:
#
# `bin/rails runner "SignificantDateReasonsDataMigration.new.migrate!"`
#
# If any project already has any reasons it will be skipped.
#
# We want to catch all the notes that relate to the stakeholder kick off tasks
# and the only way to do this is to check the note body
class SignificantDateReasonsDataMigration
  def migrate!
    projects = Project.all
    puts "#{projects.count} projects to process\n\n"

    projects.each do |project|
      puts "> Processing project with id: #{project.id}"

      date_history = project.date_history

      puts "> Project with id #{project.id} has #{date_history.count} date changes"

      date_history.each do |history_item|
        if history_item.reasons.any?
          puts ">> Date history #{history_item.id} already has reasons, skipping!"
          break
        end

        puts ">> Processing date history with id: #{history_item.id}"
        note = history_item.note
        created_at = history_item.created_at
        user = note.user

        reason = SignificantDateHistoryReason.create!(
          significant_date_history_id: history_item.id,
          reason_type: reason_type_for_note(note),
          note: note,
          created_at: created_at
        )

        puts ">>> Reason with id #{reason.id} created"

        history_item.update!(user: user)

        puts ">>> User #{user.id} added to date history"
      end

      puts "> Project with id #{project.id} finished\n\n"
    end

    puts "All projects finished"
  end

  private def reason_type_for_note(note)
    if note.body.eql?("Transfer date confirmed as part of the External stakeholder kick off task.") ||
        note.body.eql?("Conversion date confirmed as part of the External stakeholder kick off task.")
      :stakeholder_kick_off
    else
      :legacy_reason
    end
  end
end
