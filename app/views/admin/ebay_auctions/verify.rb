module Admin::EbayAuctions
  class Verify < ::Stache::View

    def listing_fees
      ebay_auction.listing_fees.map{ |fee| ListingFeePresenter.new(fee, self) }
    end

    def cancel_path
      admin_antique_ebay_auction_path( ebay_auction.antique, ebay_auction )
    end

    class ListingFeePresenter
      def initialize( fee, template )
        @fee, @template = fee, template
      end

      def description
        @fee.description.titleize
      end

      def amount
        @template.number_to_currency @fee.amount
      end
    end

  end
end