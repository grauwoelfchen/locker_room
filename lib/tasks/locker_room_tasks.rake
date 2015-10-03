require 'locker_room/plan_fetcher'

namespace :locker_room do
  desc 'Fetch and import plans from Braintree'
  task :import_plans => :environment do
    LockerRoom::PlanFetcher.store_plans_locally
  end
end
