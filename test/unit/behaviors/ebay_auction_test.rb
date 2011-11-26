require 'ostruct'
require File.expand_path( File.dirname(__FILE__) + '/../../test_helper' )

class MockEbayAuction
  include Behaviors::EbayAuction

  def listing_fees
    @listing_fees ||= MockAssociation.new
  end

  def errors
    MockErrors.new
  end
end

class MockAssociation
  def build(*); end
end

class MockErrors < Array
  def add(*); end
end

class BehaviorsEbayAuctionTest < ActiveSupport::TestCase

  setup do
    @ebay_auction = MockEbayAuction.new
    @ebay_auction.stubs( :title ).returns("Item Title")
    @ebay_auction.stubs( :description ).returns("Item Description")
    @ebay_auction.stubs( :start_price ).returns(54.47)
    @ebay_auction.stubs( :shipping_price ).returns(5.47)
  end

  subject { @ebay_auction }

  context "Given an EbayAuction that is ready for listing on eBay," do
    context "when verifying its listability on eBay" do
      context "and verification fails, it" do
        setup do
          VCR.use_cassette('item_verification_failure') do
            subject.verify_item!
          end
        end
        before_should "add the listing errors to the EbayAuction" do
          subject.errors.expects(:add).with(:base).at_most(4)
        end
      end
      context "and verification succeeds, it" do
        setup do
          VCR.use_cassette('item_verification_success') do
            subject.verify_item!
          end
        end
        before_should "indicate additional fees" do
          subject.listing_fees.expects(:build).twice
        end
      end
    end
  end

end
