require_dependency "locker_room/application_controller"

module LockerRoom
  class EntranceController < ApplicationController
    skip_filter :require_login, :only => [:index]

    def index
    end
  end
end
