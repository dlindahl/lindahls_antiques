require 'behaviors/ebay_auction'
require 'interrogatives/ebay_auction'

class EbayAuction < ActiveRecord::Base
  include Behaviors::EbayAuction

  belongs_to :antique

  validates_presence_of :antique_id, :allow_blank => false
  validates_presence_of :title, :description, :allow_blank => false

  validates_presence_of :item_number, :allow_blank => false, :if => proc { |a| a.listing_status == 'active' }
  validates_uniqueness_of :item_number

  validates_numericality_of :start_price, :greater_than_or_equal_to => 0.99
  validates_numericality_of :current_price, :greater_than_or_equal_to => proc { |auction| auction.start_price || 0.99 }
  validates_numericality_of :shipping_price, :greater_than_or_equal_to => 0.01
  validates_numericality_of :buy_it_now_price, :reserve_price, :greater_than_or_equal_to => :start_price, :allow_nil => true

  validates_numericality_of :length, :only_integer => true, :greater_than => 0
  validates_numericality_of :bids, :hit_count, :watch_count, :only_integer => true, :greater_than_or_equal_to => 0

  # Add tests for these somehow...
  validates_datetime :start_time
  validates_datetime :end_time, :date_ended, :on_or_after => :start_time, :allow_blank => true

  validate :no_other_active_auctions

  state_machine :listing_status, :initial => :draft do
    state :draft
    state :pending
    state :active
    state :completed
    state :ended

    event :submit do
      transition :draft => :pending
    end

    event :list do
      transition :pending => :active, :if => :valid?
    end
    before_transition :pending => :active do |ebay_auction|
      ebay_auction.list_auction!
    end

    event :complete do
      transition :active => :completed
    end

    event :end do
      transition :completed => :ended
    end

  end

private

  def no_other_active_auctions
    if antique and (antique.ebay_auctions - [self]).any?(&:active?)
      errors[:base] = I18n.t('activerecord.errors.models.ebay_auction.base.other_active_auctions')
    end
  end

end
