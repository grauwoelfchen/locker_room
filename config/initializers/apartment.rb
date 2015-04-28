Apartment.configure do |config|
  config.excluded_models = %w(
    LockerRoom::Account
    LockerRoom::Member
    LockerRoom::User
  )

  # migration targets
  config.tenant_names = lambda {
    Account.all.map(&:schema_name)
  }
end

Apartment::Elevators::Subdomain.excluded_subdomains = \
  LockerRoom::Account::EXCLUDED_SUBDOMAINS
