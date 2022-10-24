class PagesController < ApplicationController
  include HighVoltage::StaticPage

  skip_before_action :redirect_unauthenticated_user
end
