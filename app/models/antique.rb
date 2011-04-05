class Antique < ActiveRecord::Base

  validates_presence_of :name, :description

  validates_numericality_of :weight, :width, :height, :depth, { :allow_nil => false }

  validates_uniqueness_of :sku, :allow_blank => false
  validates_format_of :sku, :with => /\w{3}-\d+\w?\Z/, :allow_blank => false

end
