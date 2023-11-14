class Import::Gias::GroupCsvImporterService < Import::Gias::CsvImporterService
  require "csv"

  IMPORT_MAP = {
    ukprn: "UKPRN",
    unique_group_identifier: "Group UID",
    group_identifier: "Group ID",
    original_name: "Group Name",
    companies_house_number: "Companies House Number",
    address_street: "Group Street",
    address_locality: "Group Locality",
    address_additional: "Group Address 3",
    address_town: "Group Town",
    address_county: "Group County",
    address_postcode: "Group Postcode"
  }.freeze

  REQUIRED_VALUES = [
    :unique_group_identifier
  ].freeze

  def initialize(path)
    @path = path
    initialize_import_result
  end

  private def initialize_import_result
    @csv_rows = 0
    @skipped_csv_rows = 0
    @no_changes = 0
    @changed_rows = {}
    @current_records = Gias::Group.count
    @time_taken = nil
  end

  def import!
    initialize_import_result
    Rails.logger.info "[IMPORT][GIAS][GROUP] Starting import from file #{@path}"

    unless File.exist?(@path)
      Rails.logger.info "[IMPORT][GIAS][GROUP] Source file #{@path} could not be found."
      return import_result
    end

    unless required_column_headers_present?
      Rails.logger.info "[IMPORT][GIAS][GROUP] Source file #{@path} does not contain the required headers."
      return import_result
    end

    start_time = Time.now

    CSV.foreach(@path, headers: true, encoding: ENCODING) do |row|
      next unless import_row(row)
    end

    @time_taken = Time.now - start_time

    Rails.logger.info "[IMPORT][GIAS][GROUP] Finished import from file #{@path}"
    import_result
  end

  def import_row(row)
    @csv_rows += 1
    unique_group_identifier = row.field("Group UID")
    group = Gias::Group.find_or_create_by(unique_group_identifier: unique_group_identifier)

    unless required_values_empty?(row)
      Rails.logger.info "[IMPORT][GIAS][GROUP] The required fields are not present in row #{@csv_rows} - skipping row."
      @skipped_csv_rows += 1
      return false
    end

    unless group
      Rails.logger.info "[IMPORT][GIAS][GROUP] Could not find or create the group with unique_group_identifier: #{unique_group_identifier} - skipping row."
      @skipped_csv_rows += 1
      return false
    end

    Rails.logger.info "[IMPORT][GIAS][GROUP] Group found or created with unique_group_identifier: #{unique_group_identifier}."

    group_csv_attributes = csv_row_attributes(row)
    group_row_changes = changed_attributes(group_csv_attributes, group.attributes)

    if group_row_changes.any?
      if group.update(group_csv_attributes)
        Rails.logger.info "[IMPORT][GIAS][GROUP] Group updated, unique_group_identifier: #{unique_group_identifier}."
        @changed_rows[group.unique_group_identifier.to_s] = group_row_changes
      else
        Rails.logger.info "[IMPORT][GIAS][GROUP] Could not update group, unique_group_identifier: #{unique_group_identifier}."
        return false
      end
    else
      Rails.logger.info "[IMPORT][GIAS][GROUP] No changes to group, unique_group_identifier: #{unique_group_identifier}."
      @no_changes += 1
    end

    true
  end

  private def import_result
    group_records_after_import = Gias::Group.count
    {
      file: @path,
      total_csv_rows: @csv_rows,
      skipped_csv_rows: @skipped_csv_rows,
      new_groups: group_records_after_import - @current_records,
      groups_changed: @changed_rows.count - (group_records_after_import - @current_records),
      groups_not_changed: @no_changes,
      time_taken: @time_taken,
      changes: @changed_rows
    }
  end
end
