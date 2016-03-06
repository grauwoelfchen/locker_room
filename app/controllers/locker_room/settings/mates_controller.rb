require_dependency "locker_room/application_controller"

module LockerRoom
  module Settings
    class MatesController < ApplicationController
      def index
        @mates = current_team.mates
      end
    end
  end
end
