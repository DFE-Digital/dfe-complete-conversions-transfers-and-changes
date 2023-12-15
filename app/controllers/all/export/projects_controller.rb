class All::Export::ProjectsController < ApplicationController
  def index
    authorize :export
  end
end
