::ApplicationController.class_eval do
  private
    def current_account
      if logged_in?
        @current_account ||= env["Houser-Object"]
      end
    end
    helper_method :current_account

    def not_authenticated
      redirect_to login_url, :error => "Please login"
    end
end
