class FormAMultiAcademyTrust::ProjectGroupFetcherService
  def call
    fetch_project_groups
  end

  private def fetch_project_groups
    unique_trns.map do |trn|
      FormAMultiAcademyTrust::ProjectGroup.new(trn: trn)
    end
  end

  private def unique_trns
    Project.active.order(:new_trust_name).pluck(:new_trust_reference_number).uniq.compact
  end
end
