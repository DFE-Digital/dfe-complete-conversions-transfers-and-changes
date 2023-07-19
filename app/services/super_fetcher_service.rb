class SuperFetcherService
  def fetch!(projects)
    @projects = projects
    pre_fetch_academies_api
    @projects
  end

  def pre_fetch_academies_api
    establishments = []
    incoming_trusts = []
    outgoing_trusts = []


    # Bullet has to be disabled here to prevent false positives, this code
    # fetches data from the Academies APi and sets the associations on the
    # projects but does not use any eager loaded assocations that were passed
    # in and this triggers bullet
    #
    # If the calling code then didn't use the eager loading, it would be
    # captured there.
    #
    # We re-enable Bullet once this code has executed
    Bullet.enable = false if Rails.env.test?
    @projects.find_in_batches(batch_size: 10).with_index do |projects, index|
      establishment_urns  = projects.pluck(:urn).compact
      incoming_trusts_ukprns = projects.pluck(:incoming_trust_ukprn).compact
      outgoing_trusts_ukprns = projects.pluck(:outgoing_trust_ukprn).compact

      if establishment_urns.any?
        establishments.concat(pre_fetch_establishments(establishment_urns))
        set_establishments!(establishments)
      end

      if incoming_trusts_ukprns.any?
        incoming_trusts.concat(pre_fetch_trusts(incoming_trusts_ukprns))
        set_incoming_trusts!(incoming_trusts)
      end

      if outgoing_trusts_ukprns.any?
        outgoing_trusts.concat(pre_fetch_trusts(outgoing_trusts_ukprns))
        set_outgoing_trusts!(outgoing_trusts)
      end
    end
    Bullet.enable = true if Rails.env.test?
  end

  def set_establishments!(establishments)
    @projects.each do |project|
      project.establishment = establishments.find { |establishment| establishment.urn == project.urn.to_s }
    end
  end

  def set_incoming_trusts!(trusts)
    @projects.each do |project|
      project.incoming_trust = trusts.find { |trust| trust.ukprn == project.incoming_trust_ukprn.to_s }
    end
  end

  def set_outgoing_trusts!(trusts)
    @projects.each do |project|
      project.outgoing_trust = trusts.find { |trust| trust.ukprn == project.outgoing_trust_ukprn.to_s }
    end
  end

  def pre_fetch_establishments(urns)
    establishments = []
    response = Api::AcademiesApi::Client.new.get_establishments(urns)

    if response.error.nil?
      establishments.concat(response.object)
    else
      track_error(response.error)
      raise Api::AcademiesApi::Client::Error.new
    end
    establishments
  end

  def pre_fetch_trusts(ukprns)
    trusts = []
    response = Api::AcademiesApi::Client.new.get_trusts(ukprns)

    if response.error.nil?
      trusts.concat(response.object)
    else
      track_error(response.error)
      raise Api::AcademiesApi::Client::Error.new
    end
    trusts
  end
end
