::ApplicationController.class_eval do
  private
    def current_subdomain
      @current_subdomain ||= env["Houser-Subdomain"]
    end
    helper_method :current_subdomain

    def current_team
      @current_team ||= env["Houser-Object"]
    end
    helper_method :current_team

    def login_with_subdomain(*credentials)
      return nil unless current_subdomain
      return nil unless email = credentials[0]
      return nil unless team = current_team
      return nil unless team.users.find_by(:email => email)
      login(*credentials)
    end

    def not_authenticated
      redirect_to locker_room.login_url, :alert => "Please signin."
    end
end
