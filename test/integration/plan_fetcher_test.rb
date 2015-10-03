require 'test_helper'
require 'locker_room/plan_fetcher'

class PlanFetcherTest < ActionDispatch::IntegrationTest
  def setup
    @plan = mock('Plan',
                 :id => 'foo1', :name => 'Starter', :price => '9.95')
  end

  def test_creation_by_store_plans_locally
    @plan.expects(:id).returns('foo1').once
    Braintree::Plan.expects(:all).returns([@plan])
    LockerRoom::Plan.expects(:find_by)
      .with(:braintree_id => 'foo1').returns(nil)
    LockerRoom::Plan.expects(:create).with(
      :braintree_id => 'foo1',
      :name         => 'Starter',
      :price        => '9.95'
    )
    LockerRoom::PlanFetcher.store_plans_locally
  end

  def test_update_by_store_plans_locally
    @plan.expects(:update_attributes).with(
      :name  => 'Starter',
      :price => '9.95'
    ).once
    Braintree::Plan.expects(:all).returns([@plan])
    LockerRoom::Plan.expects(:find_by)
      .with(:braintree_id => 'foo1').returns(@plan)
    LockerRoom::Plan.expects(:create).never
    LockerRoom::PlanFetcher.store_plans_locally
  end
end
