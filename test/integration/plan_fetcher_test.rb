require 'test_helper'
require 'locker_room/plan_fetcher'

class PlanFetcherTest < ActionDispatch::IntegrationTest
  def setup
    @plan = mock('Plan',
                 :id => 'foo1', :name => 'Starter', :price => '9.95')
  end

  def test_creation_by_store_types_locally
    @plan.expects(:id).returns('foo1').once
    Braintree::Plan.expects(:all).returns([@plan])
    LockerRoom::Type.expects(:find_by)
      .with(:plan_id => 'foo1').returns(nil)
    LockerRoom::Type.expects(:create!).with(
      :plan_id => 'foo1',
      :name    => 'Starter',
      :price   => '9.95'
    )
    LockerRoom::PlanFetcher.store_types_locally
  end

  def test_update_by_store_types_locally
    @plan.expects(:update_attributes!).with(
      :name  => 'Starter',
      :price => '9.95'
    ).once
    Braintree::Plan.expects(:all).returns([@plan])
    LockerRoom::Type.expects(:find_by)
      .with(:plan_id => 'foo1').returns(@plan)
    LockerRoom::Type.expects(:create!).never
    LockerRoom::PlanFetcher.store_types_locally
  end
end
