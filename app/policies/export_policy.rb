class ExportPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
  end

  def index?
    csv?
  end

  def show?
    csv?
  end

  def new?
    csv?
  end

  def create?
    csv?
  end

  def csv?
    return true if @user.education_and_skills_funding_agency_team?
    return true if @user.academies_operational_practice_unit_team?
    return true if @user.business_support_team?
    return true if @user.service_support_team?

    false
  end

  def service_support?
    return true if @user.service_support_team?

    false
  end
end
