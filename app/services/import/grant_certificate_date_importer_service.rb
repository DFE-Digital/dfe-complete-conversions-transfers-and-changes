require "csv"

class Import::GrantCertificateDateImporterService
  def call(csv_path)
    CSV.foreach(csv_path, headers: true, header_converters: :symbol) do |row|
      urn = row[:urn]
      next unless urn

      project = Project.find_by(academy_urn: urn.to_i)
      unless project
        puts "Unable to find project with academy_urn: #{urn}"
        next
      end

      tasks_data = project.tasks_data
      next unless tasks_data

      date_string = row[:date].to_s
      date = Date.strptime(date_string, "%d/%m/%Y")
      tasks_data.receive_grant_payment_certificate_date_received = date
      tasks_data.save(validate: false)
      puts "Updated grant payment certificate date for project with academy_urn: #{urn}"
    rescue Date::Error
      puts "Date for URN #{urn} is not valid"
    end
  end
end
