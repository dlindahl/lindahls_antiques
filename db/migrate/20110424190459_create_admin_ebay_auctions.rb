class CreateAdminEbayAuctions < ActiveRecord::Migration
  def self.up
    create_table :ebay_auctions do |t|
      t.string :title, :item_number, :listing_status, :time_left
      t.text :description
      t.decimal :start_price, :current_price, :precision => 7, :scale => 2, :default => 0.99
      t.decimal :reserve_price, :buy_it_now_price, :shipping_price, :precision => 7, :scale => 2
      t.integer :antique_id, :primary_category_id, :winner_id
      t.integer :length
      t.integer :bids, :hit_count, :watch_count, :default => 0
      t.boolean :reserve_met, :default => false
      t.datetime :start_time, :end_time, :date_ended

      t.timestamps
    end
  end

  def self.down
    drop_table :ebay_auctions
  end
end
