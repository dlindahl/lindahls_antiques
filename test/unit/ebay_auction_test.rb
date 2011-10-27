require File.dirname(__FILE__) + '/../test_helper'

class EbayAuctionTest < ActiveSupport::TestCase

  should have_db_column(:title)
  should have_db_column(:description)
  should have_db_column(:start_price)
  should have_db_column(:current_price)
  should have_db_column(:reserve_price)
  should have_db_column(:buy_it_now_price)
  should have_db_column(:shipping_price)
  should have_db_column(:antique_id)
  should have_db_column(:item_number)
  should have_db_column(:length)
  should have_db_column(:bids)
  should have_db_column(:hit_count)
  should have_db_column(:watch_count)
  should have_db_column(:reserve_met)
  should have_db_column(:listing_status)
  should have_db_column(:time_left)
  should have_db_column(:start_time)
  should have_db_column(:end_time)
  should have_db_column(:date_ended)
  should have_db_column(:primary_category_id)
  should have_db_column(:winner_id)

  should belong_to(:antique)

  should validate_presence_of(:title)
  should validate_presence_of(:description)

  should_not allow_value('').for(:title)
  should_not allow_value('').for(:description)

  should validate_numericality_of(:start_price)
  should validate_numericality_of(:current_price)
  should validate_numericality_of(:shipping_price)
  should validate_numericality_of(:buy_it_now_price)
  should validate_numericality_of(:reserve_price)

  should_not allow_value(nil).for(:start_price)
  should_not allow_value(nil).for(:current_price)
  should_not allow_value(nil).for(:shipping_price)

  should allow_value(nil).for(:buy_it_now_price)
  should allow_value(nil).for(:reserve_price)

  should_not allow_value('').for(:start_price)
  should_not allow_value('').for(:current_price)
  should_not allow_value('').for(:shipping_price)

  should allow_value('').for(:buy_it_now_price)
  should allow_value('').for(:reserve_price)

  should allow_value(0.99).for(:start_price)
  should allow_value(0.99).for(:current_price)

  should_not allow_value(0.98).for(:start_price)
  should_not allow_value(0.98).for(:current_price)

  should_not allow_value(0).for(:shipping_price)
  should_not allow_value(0).for(:buy_it_now_price)
  should_not allow_value(0).for(:reserve_price)

  should validate_numericality_of(:length)

  should_not allow_value('').for(:length)
  should_not allow_value(0).for(:length)
  should_not allow_value(0.1).for(:length)

  should validate_numericality_of(:bids)
  should validate_numericality_of(:hit_count)
  should validate_numericality_of(:watch_count)

  should_not allow_value('').for(:bids)
  should_not allow_value('').for(:hit_count)
  should_not allow_value('').for(:watch_count)

  should_not allow_value(-1).for(:bids)
  should_not allow_value(-1).for(:hit_count)
  should_not allow_value(-1).for(:watch_count)

  should_not allow_value(0.1).for(:bids)
  should_not allow_value(0.1).for(:hit_count)
  should_not allow_value(0.1).for(:watch_count)

  should allow_value(0).for(:bids)
  should allow_value(0).for(:hit_count)
  should allow_value(0).for(:watch_count)

  should_not allow_value(nil).for(:listing_status)
  should_not allow_value('').for(:listing_status)

  context "An instance of EbayAuction" do
    context "with a start price set" do
      subject { EbayAuction.new(:start_price => 54.0) }
      should_not allow_value(53.9).for(:current_price)
      should_not allow_value(53.9).for(:buy_it_now_price)
      should_not allow_value(53.9).for(:reserve_price)

      should allow_value(54.0).for(:current_price)
      should allow_value(54.0).for(:buy_it_now_price)
      should allow_value(54.0).for(:reserve_price)
    end
    context "that is submitted" do
      subject { EbayAuction.make(:antique => Antique.make) }
      setup do
        @auction = subject
        @auction.submit!
      end
      should "be pending" do
        assert_equal "pending", @auction.listing_status
      end
    end
    context "that is listed" do
      subject { EbayAuction.make(:antique => Antique.make, :listing_status => 'pending') }
      setup do
        @auction = subject
        @auction.list!
      end
      before_should "attempt to list the Auction on Ebay" do
        EbayAuction.any_instance.expects(:list_auction!)
      end
      should "be Active" do
        assert_equal "active", @auction.listing_status
      end
    end
    context "that is completed" do
      subject { EbayAuction.make(:antique => Antique.make, :listing_status => 'active') }
      setup do
        @auction = subject
        @auction.complete!
      end
      should "be Completed" do
        assert_equal "completed", @auction.listing_status
      end
    end
    context "that is ended" do
      subject { EbayAuction.make(:antique => Antique.make, :listing_status => 'completed') }
      setup do
        @auction = subject
        @auction.end!
      end
      should "be Ended" do
        assert_equal "ended", @auction.listing_status
      end
    end
  end

  context "A saved instance of EbayAuction" do
    subject { EbayAuction.make(:antique => Antique.make) }
    should validate_presence_of(:antique_id)
    context "that is Active" do
      subject { EbayAuction.make(:antique => Antique.make, :listing_status => 'active') }
      should validate_uniqueness_of(:item_number)
      should validate_presence_of(:item_number)
      should_not allow_value('').for(:item_number)
    end
  end

end
