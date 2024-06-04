# :nocov:
module Export::Csv::MpPresenterModule
  def mp_name
    return if @project.member_of_parliament.nil?

    @project.member_of_parliament.name
  end

  def mp_email
    return if @project.member_of_parliament.nil?

    @project.member_of_parliament.email
  end

  def mp_constituency
    return if @project.member_of_parliament.nil?

    @project.establishment.parliamentary_constituency
  end

  def mp_address_1
    return if @project.member_of_parliament.nil?

    @project.member_of_parliament.address.line1
  end

  def mp_address_2
    return if @project.member_of_parliament.nil?

    @project.member_of_parliament.address.line2
  end

  def mp_address_3
    return if @project.member_of_parliament.nil?

    @project.member_of_parliament.address.line3
  end

  def mp_address_postcode
    return if @project.member_of_parliament.nil?

    @project.member_of_parliament.address.postcode
  end
end
# :nocov:
