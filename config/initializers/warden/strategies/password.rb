Warden::Strategies.add(:password) do
  def subdomain
    ActionDispatch::Http::URL.extract_subdomains(request.host, 1)
  end

  def valid?
    subdomain.present? && params['user']
  end

  def authenticate!
    return fail! unless team = LockerRoom::Team.find_by(:subdomain => subdomain)
    return fail! unless user = team.users.find_by(:email => params['user']['email'])
    return fail! unless user.authenticate(params['user']['password'])
    success!(user)
    # user = LockerRoom::User.find_by(email: params['user']['email'])
    # if user && user.authenticate(params['user']['password'])
    #   success!(user)
    # else
    #   fail!
    # end
  end
end
