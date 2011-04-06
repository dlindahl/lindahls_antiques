class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :antique_id, :width, :height
      t.string :title, :url, :page, :size

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
