class HomeController < ApplicationController
  include Authentication

  def index
    @projects = Project.all
  end
end
