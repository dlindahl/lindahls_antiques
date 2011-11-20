module Admin::EbayAuctions
  class Sidebar < ::Stache::View

    def ebay_auctions
      antique.ebay_auctions.map{ |ebay_auction| EbayAuctionPresenter.new(ebay_auction, self) }
    end

    def auction_off_link
      link_to 'Auction Off?', new_admin_antique_ebay_auction_path(antique)
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
        @object.valid? ? "Ready to list!" : "Not ready for listing."
      end

      def pending_result
        "Preparing to list on eBay."
      end

      # TODO: i18n this stuff?
      # ebay_auction -> results (activity?) -> none|bids+price+views+watchers|completed|ended, etc.
      def active_result
        if @object.bids.zero? and @object.hit_count.zero? and @object.watch_count.zero?
          "No activity"
        else
          [].tap do |output|
            if @object.bids
              output << @template.pluralize( @object.bids, 'bid' ) + " for #{@template.number_to_currency(@object.current_price)}".tap do |bid_output|
                bid_output << " (reserve not met)" unless @object.reserve_met?
              end
            end
            output << "#{@object.hit_count} views" if @object.hit_count
            output << "#{@object.watch_count} watchers" if @object.watch_count
          end.to_sentence
        end
      end

      # TODO: Implement
      def completed_result
        "[COMPLETED RESULT CONTENT NOT AVAILABLE]"
      end

      # TODO: Implement
      def ended_result
        "[ENDED RESULT CONTENT NOT AVAILABLE]"
      end

    end

  end
end