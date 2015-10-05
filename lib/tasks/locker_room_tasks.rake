require 'locker_room/plan_fetcher'

namespace :locker_room do
  desc 'Fetch and import types from Braintree plans'
  task :import_types => :environment do
    LockerRoom::PlanFetcher.store_types_locally
  end
end
