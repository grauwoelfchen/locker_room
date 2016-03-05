module LockerRoom::AuthenticationMethods
  private

  def login_with_subdomain(*credentials)
    return nil unless current_subdomain && current_team
    email, password = credentials
    return nil unless email
    user = current_team.mates.find_by(:email => email)
    return nil unless user
    if user.authenticate(password)
      force_authentication!(user)
    else
      false
    end
  end

  def force_authentication!(user)
    warden.set_user(user, :scope => :user)
  end

  def authenticate_user!
    not_authenticated unless user_signed_in?
  end

  def not_authenticated
    redirect_to locker_room.login_url, :alert => 'Please signin.'
  end

  def logout
    warden.logout
  end

  def warden
    env['warden'] || request.env['warden']
  end
end

::ApplicationController.class_eval do
  include LockerRoom::AuthenticationMethods

  private

  def current_subdomain
    @current_subdomain ||= env['Houser-Subdomain']
  end
  helper_method :current_subdomain

  def current_team
    @current_team ||= env['Houser-Object']
  end
  helper_method :current_team

  def current_user
    if user_signed_in?
      @current_user ||= warden.user(:scope => :user)
    end
  end
  helper_method :current_user

  def authorize_owner
    unless owner?
      flash[:alert] = 'You are not allowed to do that.'
      redirect_to locker_room.root_url
    end
  end

  def user_signed_in?
    warden.authenticated?(:user)
  end
  helper_method :user_signed_in?

  def owner?
    current_team.owner?(current_user)
  end
  helper_method :owner?
end
