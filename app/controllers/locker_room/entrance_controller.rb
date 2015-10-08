require_dependency 'locker_room/application_controller'

module LockerRoom
  class EntranceController < ApplicationController
    skip_filter :authenticate_user!, only: [:index]

    def index
    end
  end
end
