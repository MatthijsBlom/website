require_relative '../test_base'

class Donations::Stripe::SyncSubscriptionsTest < Donations::TestBase
  test "creates subscription for subscriptions only in Stripe" do
    # TODO
  end

  test "does not change subscriptions that match Stripe" do
    # TODO
  end

  test "cancels subscriptions that are not active in Stripe" do
    # TODO
  end
end
