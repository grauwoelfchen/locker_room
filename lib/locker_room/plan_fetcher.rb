module LockerRoom
  class PlanFetcher
    # Imports Braintree::Plan as LockerRoom::Type
    def self.store_types_locally
      Braintree::Plan.all.each do |plan|
        type = LockerRoom::Type.find_by(plan_id: plan.id)
        if type
          type.update_attributes!(
            :name  => plan.name,
            :price => plan.price
          )
        else
          LockerRoom::Type.create!(
            :plan_id => plan.id,
            :name    => plan.name,
            :price   => plan.price,
          )
        end
      end
    end
  end
end
