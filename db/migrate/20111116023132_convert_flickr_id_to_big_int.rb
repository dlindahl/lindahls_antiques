class ConvertFlickrIdToBigInt < ActiveRecord::Migration
  def change
    change_column :photos, :flickr_id, :integer, :limit => 8
  end
end
