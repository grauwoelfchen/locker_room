Apartment.configure do |config|
  config.excluded_models = %w(
    LockerRoom::Account
    LockerRoom::Member
    LockerRoom::User
  )
end

Apartment::Elevators::Subdomain.excluded_subdomains = %w(
  www
)
