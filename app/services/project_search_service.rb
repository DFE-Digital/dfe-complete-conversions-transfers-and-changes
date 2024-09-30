class ProjectSearchService
  def search(query)
    if urn_pattern(query)
      search_by_urns(query)
    elsif ukprn_pattern(query)
      search_by_ukprn(query)
    elsif establishment_number_pattern(query)
      search_by_establishment_number(query)
    else
      search_by_words(query)
    end
  end

  def search_by_urns(urns)
    Project.not_deleted.not_inactive.where(urn: urns).includes(:assigned_to)
  end

  def search_by_ukprn(ukprn)
    Project.not_deleted.not_inactive.where("incoming_trust_ukprn = ?", ukprn)
      .or(Project.not_deleted.not_inactive.where("outgoing_trust_ukprn = ?", ukprn)).includes(:assigned_to)
  end

  def search_by_words(query)
    establishment_results = search_establishments_by_name(query)
    return [] if establishment_results.empty?

    urns = establishment_results.pluck(:urn)
    search_by_urns(urns)
  end

  private def search_establishments_by_name(query)
    Gias::Establishment.where("LOWER(name) LIKE ?", "%#{query.downcase}%")
  end

  def search_by_establishment_number(query)
    establishment_results = search_establishments_by_establishment_number(query)
    return [] if establishment_results.empty?

    urns = establishment_results.pluck(:urn)
    search_by_urns(urns)
  end

  private def search_establishments_by_establishment_number(query)
    Gias::Establishment.where(establishment_number: query)
  end

  private def urn_pattern(query)
    query.match?(/^\d{6}$/)
  end

  private def ukprn_pattern(query)
    query.match?(/^\d{8}$/)
  end

  private def establishment_number_pattern(query)
    query.match?(/^\d{4}$/)
  end
end
