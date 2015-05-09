::ApplicationController.class_eval do
  private
    def current_subdomain
      @current_subdomain ||= env["Houser-Subdomain"]
    end
    helper_method :current_subdomain

    def current_account
      @current_account ||= env["Houser-Object"]
    end
    helper_method :current_account

    def login_with_subdomain(*credentials)
      return nil unless current_subdomain
      return nil unless email = credentials[0]
      return nil unless account = current_account
      return nil unless account.users.find_by(:email => email)
      login(*credentials)
    end

    def not_authenticated
      redirect_to locker_room.login_url, :alert => "Please signin."
    end
end
