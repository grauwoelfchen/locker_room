module LockerRoom
  class PlanFetcher
    def self.store_plans_locally
      Braintree::Plan.all.each do |plan|
        stored_plan = LockerRoom::Plan.find_by(braintree_id: plan.id)
        if stored_plan
          stored_plan.update_attributes(
            :name  => plan.name,
            :price => plan.price
          )
        else
          LockerRoom::Plan.create(
            :braintree_id => plan.id,
            :name         => plan.name,
            :price        => plan.price,
          )
        end
      end
    end
  end
end
