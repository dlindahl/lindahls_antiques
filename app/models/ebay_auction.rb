class EbayAuction < ActiveRecord::Base

  belongs_to :antique

  validates_presence_of :antique_id, :allow_blank => false
  validates_presence_of :title, :description, :item_number, :allow_blank => false

  validates_numericality_of :start_price, :greater_than_or_equal_to => 0.99
  validates_numericality_of :current_price, :greater_than_or_equal_to => proc { |auction| auction.start_price || 0.99 }
  validates_numericality_of :shipping_price, :greater_than => 0
  validates_numericality_of :buy_it_now_price, :reserve_price, :greater_than_or_equal_to => :start_price, :allow_nil => true

  validates_numericality_of :length, :only_integer => true, :greater_than => 0
  validates_numericality_of :bids, :hit_count, :watch_count, :only_integer => true, :greater_than_or_equal_to => 0

  # Add tests for these somehow...
  validates_datetime :start_time
  validates_datetime :end_time, :date_ended, :on_or_after => :start_time, :allow_blank => true

  validates_uniqueness_of :item_number

end
