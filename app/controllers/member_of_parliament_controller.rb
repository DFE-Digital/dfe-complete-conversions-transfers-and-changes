class MemberOfParliamentController < ApplicationController
  include Projectable

  def show
    @member = @project.member_of_parliament
  end
end
