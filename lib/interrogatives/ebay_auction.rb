module Interrogatives
  module EbayAuction

    def reserve_met?
      reserve_price.nil? or current_price >= reserve_price
    end

  end
end