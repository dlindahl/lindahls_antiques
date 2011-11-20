require File.expand_path( File.dirname(__FILE__) + '/../../test_helper' )

class InterrogativesEbayAuctionTest < ActiveSupport::TestCase

  context "When there is no reserve price it" do
    subject { mock('ebay_auction', :reserve_price => nil).extend(Interrogatives::EbayAuction) }
    should "indicate that the reserve price was met" do
      assert subject.reserve_met?
    end
  end

  context "When there is a reserve price" do
    context "and the current price is" do
      context "higher than the reserve price it" do
        subject do
          mock('ebay_auction', :current_price => 10.0).extend(Interrogatives::EbayAuction).tap do |ebay_auction|
            ebay_auction.stubs(:reserve_price => 1.0)
          end
        end
        should "indicate that the reserve price was met" do
          assert subject.reserve_met?
        end
      end
      context "equal to the reserve price it" do
        subject do
          mock('ebay_auction', :current_price => 10.0).extend(Interrogatives::EbayAuction).tap do |ebay_auction|
            ebay_auction.stubs(:reserve_price => 10.0)
          end
        end
        should "indicate that the reserve price was met" do
          assert subject.reserve_met?
        end
      end
      context "lower than the reserve price it" do
        subject do
          mock('ebay_auction', :current_price => 10.0).extend(Interrogatives::EbayAuction).tap do |ebay_auction|
            ebay_auction.stubs(:reserve_price => 20.0)
          end
        end
        should "inidcate that the reserve price was NOT met" do
          assert_equal false, subject.reserve_met?
        end
      end
    end
  end

end
