ActiveAdmin.register EbayAuction do
  # Keep this? I think I want Antique to drive everything
  index do |ebay_auction|
    column "SKU" do |ebay_auction|
      ebay_auction.antique.sku
    end
    column :item_number
    column :title
    column :listing_status do |ebay_auction|
      ebay_auction.listing_status.titleize
    end
    column :bids
    column :start_price
    column :current_price
    column :reserve_price
    column :buy_it_now_price
    column :reserve_met
    column :time_left
    column :end_time
    column :date_ended
  end

end
