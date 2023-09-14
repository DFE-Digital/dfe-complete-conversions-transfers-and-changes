class ProjectSearchService
  def search(query)
    if urn_pattern(query)
      return search_by_urn(query)
    end

    if ukprn_pattern(query)
      return search_by_ukprn(query)
    end

    []
  end

  def search_by_urn(urn)
    Project.where("urn = ?", urn)
  end

  def search_by_ukprn(ukprn)
    Project.where("incoming_trust_ukprn = ?", ukprn)
      .or(Project.where("outgoing_trust_ukprn = ?", ukprn))
  end

  private def urn_pattern(query)
    query.match?(/^\d{6}$/)
  end

  private def ukprn_pattern(query)
    query.match?(/\d{8}$/)
  end
end
