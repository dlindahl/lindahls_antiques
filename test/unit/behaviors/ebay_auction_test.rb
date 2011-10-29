require File.dirname(__FILE__) + '/../../test_helper'

class BehaviorsEbayAuctionTest < ActiveSupport::TestCase
  subject { EbayAuction.new }

  should "respond to :list_auction!" do
    assert subject.respond_to?(:list_auction!)
  end
end
