require File.expand_path( File.dirname(__FILE__) + '/../../../../test_helper' )

class Admin::EbayAuctions::VerifyTest < ActiveSupport::TestCase
  Admin::EbayAuctions::Verify.send(:include, ActionView::Helpers::UrlHelper)
  include ActionView::Helpers::NumberHelper

  subject do
    Admin::EbayAuctions::Verify.new.tap do |mock|
      ebay_auction = mock('MockEbayAuction')
      ebay_auction.stubs(:antique).returns(nil)
      listing_fee = mock('MockListingFee')
      ebay_auction.stubs(:listing_fees).returns([ listing_fee ])
      mock.stubs(:ebay_auction).returns( ebay_auction )
    end
  end

  should "return a collection of Presenters for each auction's fees" do
    assert subject.listing_fees.is_a? Array
    assert subject.listing_fees.first.is_a? Admin::EbayAuctions::Verify::ListingFeePresenter
  end

  should "return a #show path when cancelling listing" do
    subject.expects(:admin_antique_ebay_auction_path).returns('/foo')
    assert_equal "/foo", subject.cancel_path
  end

  context "The Sidebar::EbayAuctionPresenter" do
    setup do
      @listing_fee = mock('MockListingFee')
      @listing_fee.stubs(:description).returns("FeeName")
      @listing_fee.stubs(:amount).returns(5.47)
    end
    subject { Admin::EbayAuctions::Verify::ListingFeePresenter.new(@listing_fee, self) }

    should "return a human readable description" do
      assert_equal "Fee Name", subject.description
    end

    should "return a currency formatted amount" do
      assert_equal "$5.47", subject.amount
    end
  end

end