require_dependency 'locker_room/application_controller'

module LockerRoom
  class EntranceController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]

    # Welcome page
    def index
    end
  end
end
