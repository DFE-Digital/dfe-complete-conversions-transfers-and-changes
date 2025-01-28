class BackfillMissingDateHistoryReasonNotes < ActiveRecord::Migration[7.1]
  def up
    logger = proc { |msg|
      Kernel.puts msg
      Rails.logger.info msg
    }

    logger.call("Backfilling missing DateHistoryReason notes...")
    diff =
      SignificantDateHistoryReason.count -
      SignificantDateHistoryReason.joins(:note).count

    if diff.zero?
      logger.call("All reasons already have a note")
      return
    end

    logger.call("  -> There are #{diff} reasons which are missing a note:")

    problem_reasons = SignificantDateHistoryReason
      .left_outer_joins(:note)
      .where("notes.id IS NULL")

    problem_reasons_count = problem_reasons.count

    if problem_reasons_count != diff
      logger.call(
        "  Error: the count of reasons without notes #{problem_reasons_count} is " \
        "not the same as our earlier diff #{diff}"
      )
      return
    end

    logger.call(
      "  Fixing up #{problem_reasons_count} SignificantDateHistoryReasons missing " \
      "their Notes:"
    )

    problem_reasons.each do |reason|
      date = reason.significant_date_history
      begin
        new_note = reason.create_note!(
          user_id: date.user_id,
          project_id: date.project_id,
          body: "Blank (reason unknown)"
        )

        logger.call("  - yes: new note created: #{new_note.attributes}")
      rescue ActiveRecord::RecordInvalid => error
        logger.call("  - no: new note could not be created #{error}")
      end
    end

    diff =
      SignificantDateHistoryReason.count -
      SignificantDateHistoryReason.joins(:note).count

    logger.call(
      "Finished backfilling missing DateHistoryReason notes. There are " \
     "now #{diff} reasons missing a note."
    )
  end
end
