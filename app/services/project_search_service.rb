class ProjectSearchService
  def search(query)
    if urn_pattern(query)
      return search_by_urns(query)
    end

    if ukprn_pattern(query)
      return search_by_ukprn(query)
    end

    if word_pattern(query)
      return search_by_words(query)
    end

    []
  end

  def search_by_urns(urns)
    Project.where(urn: urns)
  end

  def search_by_ukprn(ukprn)
    Project.where("incoming_trust_ukprn = ?", ukprn)
      .or(Project.where("outgoing_trust_ukprn = ?", ukprn))
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

  private def urn_pattern(query)
    query.match?(/^\d{6}$/)
  end

  private def ukprn_pattern(query)
    query.match?(/^\d{8}$/)
  end

  private def word_pattern(query)
    query.match?(/\D/)
  end
end
