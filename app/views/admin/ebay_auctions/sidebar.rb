module Admin::EbayAuctions
  class Sidebar < ::Stache::View

    def ebay_auctions
      antique.ebay_auctions.map{ |ebay_auction| EbayAuctionPresenter.new(ebay_auction, self) }
    end

    def create_auction_path
      new_admin_antique_ebay_auction_path(antique)
    end

    class EbayAuctionPresenter

      def initialize( ebay_auction, template )
        @object, @template = ebay_auction, template
      end

      def humanized_created_at
        @object.created_at.strftime('%A, %B %d, %Y at %l:%M%p')
      end

      def show_auction_path
        @template.admin_antique_ebay_auction_path( antique, @object )
      end

      def creation_time_span
        @template.time_ago_in_words( @object.created_at )
      end

      def listing_result
        self.send( "#{@object.listing_status}_result" )
      end

      def respond_to?( method_id, include_private = false )
        super || @object.respond_to?( method_id, include_private )
      end

      def method_missing( method_id, *args )
        if @object.respond_to?(method_id)
          @object.send(method_id, *args)
        else
          super
        end
      end

    private

      def draft_result
        I18n.t "status.ebay_auction.listing.draft." + (@object.valid? ? "valid" : "invalid") + "_record"
      end

      def pending_result
        I18n.t "status.ebay_auction.listing.pending"
      end

      # TODO: i18n this stuff?
      # ebay_auction -> results (activity?) -> none|bids+price+views+watchers|completed|ended, etc.
      def active_result
        if @object.bids.zero? and @object.hit_count.zero? and @object.watch_count.zero?
          I18n.t "status.ebay_auction.listing.active.no_activity"
        else
          [].tap do |output|
            if @object.bids
              output << @template.pluralize( @object.bids, I18n.t("status.ebay_auction.listing.active.bids") ) +
                        I18n.t( "status.ebay_auction.listing.active.current_price", :current_price => @template.number_to_currency(@object.current_price) ).tap do |bid_output|
                bid_output << I18n.t( "status.ebay_auction.listing.active.unmet_reserve" ) unless @object.reserve_met?
              end
            end
            output << I18n.t( "status.ebay_auction.listing.active.views", :hit_count => @object.hit_count ) if @object.hit_count
            output << I18n.t( "status.ebay_auction.listing.active.watchers", :watch_count => @object.watch_count ) if @object.watch_count
          end.to_sentence
        end
      end

      # TODO: Implement
      def completed_result
        I18n.t( "status.ebay_auction.listing.completed" )
      end

      # TODO: Implement
      def ended_result
        I18n.t( "status.ebay_auction.listing.ended" )
      end

    end

  end
end