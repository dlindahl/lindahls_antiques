class CreateAntiques < ActiveRecord::Migration
  def self.up
    create_table :antiques do |t|
      t.string :name, :sku
      t.text :description
      t.float :width, :height, :depth, :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :antiques
  end
end
