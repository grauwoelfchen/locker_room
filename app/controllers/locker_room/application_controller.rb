module LockerRoom
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    before_filter :require_login

    private

      def authorize_owner
        unless owner?
          flash[:error] = 'You are not allowed to do that.'
          redirect_to locker_room.root_url
        end
      end
  end
end
