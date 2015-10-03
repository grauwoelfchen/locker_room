module LockerRoom::LoginMethods
  private

    def login_with_subdomain(*credentials)
      return nil unless current_subdomain && current_team
      email = credentials[0]
      return nil unless email
      return nil unless current_team.users.find_by(:email => email)
      login(*credentials)
    end
end

::ApplicationController.class_eval do
  include LockerRoom::LoginMethods

  private

    def current_subdomain
      @current_subdomain ||= env['Houser-Subdomain']
    end
    helper_method :current_subdomain

    def current_team
      @current_team ||= env['Houser-Object']
    end
    helper_method :current_team

    def owner?
      current_team.owner?(current_user)
    end
    helper_method :owner?

    def not_authenticated
      redirect_to locker_room.login_url, :alert => 'Please signin.'
    end
end
