module Interrogatives
  module Antique

    def thumbnail?
      not photos.empty?
    end

    def under_auction?
      ebay_auctions.detect{ |auction| auction.active? }
    end

  end
end