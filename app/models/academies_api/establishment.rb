class AcademiesApi::Establishment
  def initialize(body)
    @raw = JSON.parse(body)
  end

  def name
    @raw.fetch("establishmentName")
  end
end
