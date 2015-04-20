class TalksController < ApplicationController
  def index
    @talks = Talk.scoped_to(current_account)
  end
end
