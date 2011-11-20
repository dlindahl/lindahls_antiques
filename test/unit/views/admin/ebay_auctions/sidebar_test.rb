require File.expand_path( File.dirname(__FILE__) + '/../../../../test_helper' )

class Admin::EbayAuctions::SidebarTest < ActiveSupport::TestCase
  Admin::EbayAuctions::Sidebar.send(:include, ActionView::Helpers::UrlHelper)

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  subject do
    Admin::EbayAuctions::Sidebar.new.tap do |mock|
      antique = mock('MockResource')
      ebay_auction = mock('MockEbayAuction')
      antique.stubs(:ebay_auctions).returns([ ebay_auction ])
      mock.stubs(:antique).returns( antique )
    end
  end

  should "return a collection of Presenters for each item's auctions" do
    assert subject.ebay_auctions.is_a? Array
    assert subject.ebay_auctions.first.is_a? Admin::EbayAuctions::Sidebar::EbayAuctionPresenter
  end

  should "generate a link to auction off the item" do
    subject.expects(:new_admin_antique_ebay_auction_path).returns('/foo')

    assert_equal %q{<a href="/foo">Auction Off?</a>}, subject.auction_off_link
  end

  context "The Sidebar::EbayAuctionPresenter" do
    setup do
      @antique = mock('MockAntique')
      @ebay_auction = mock('MockEbayAuction')
      @ebay_auction.stubs(:antique).returns( @antique )
      @ebay_auction.stubs(:title).returns('Mock eBay Auction Title')
      @ebay_auction.stubs(:created_at).returns( Time.local(2011, 9, 11, 8, 46, 30) )
    end
    subject do
      Admin::EbayAuctions::Sidebar::EbayAuctionPresenter.new(@ebay_auction, self) do |presenter|
      end
    end
    should "delegate unknown methods to the object it represents" do
      assert_equal "Mock eBay Auction Title", subject.title
    end
    should "return a human readable created at value" do
      # TODO: Why is this a Sunday?
      assert_equal "Sunday, September 11, 2011 at  8:46AM", subject.humanized_created_at
    end
    should "generate a URL to view the representative auction" do
      expects(:admin_antique_ebay_auction_path).returns('/foo')
      assert_equal "/foo", subject.show_auction_path
    end
    should "indicate how long ago the auction was created" do
      expects(:time_ago_in_words).with( subject.created_at )
      subject.creation_time_span
    end
    context "when representing an auction that" do
      context "is a draft" do
        setup { @ebay_auction.stubs(:listing_status).returns("draft") }
        context "and is valid" do
          setup { @ebay_auction.stubs(:valid?).returns(true) }
          should "indicate a specific listing result" do
            assert_equal "Ready to list!", subject.listing_result
          end
        end
        context "is invalid" do
          setup { @ebay_auction.stubs(:valid?).returns(false) }
          should "indicate a specific listing result" do
            assert_equal "Not ready for listing.", subject.listing_result
          end
        end
      end
      context "is pending" do
        setup { @ebay_auction.stubs(:listing_status).returns("pending") }
        should "indicate a specific listing result" do
          assert_equal "Preparing to list on eBay.", subject.listing_result
        end
      end
      context "is active" do
        setup { @ebay_auction.stubs(:listing_status).returns("active") }
        context "with no activity" do
          setup do
            @ebay_auction.stubs(:bids).returns(0)
            @ebay_auction.stubs(:hit_count).returns(0)
            @ebay_auction.stubs(:watch_count).returns(0)
          end
          should "indicate a specific listing result" do
            assert_equal "No activity", subject.listing_result
          end
        end
        context "with bids, watchers, hits, and an unmet reserve price" do
          setup do
            @ebay_auction.stubs(:bids).returns(10)
            @ebay_auction.stubs(:current_price).returns(54.47)
            @ebay_auction.stubs(:hit_count).returns(11)
            @ebay_auction.stubs(:watch_count).returns(12)
            @ebay_auction.stubs(:reserve_met?).returns(false)
          end
          should "indicate a specific listing result" do
            assert_equal "10 bids for $54.47 (reserve not met), 11 views, and 12 watchers", subject.listing_result
          end
        end
      end
      context "has completed" do
        setup { @ebay_auction.stubs(:listing_status).returns("completed") }
        should "indicate a specific listing result" do
          assert_equal "[COMPLETED RESULT CONTENT NOT AVAILABLE]", subject.listing_result
        end
      end
      context "has ended" do
        setup { @ebay_auction.stubs(:listing_status).returns("ended") }
        should "indicate a specific listing result" do
          assert_equal "[ENDED RESULT CONTENT NOT AVAILABLE]", subject.listing_result
        end
      end
    end
  end

end