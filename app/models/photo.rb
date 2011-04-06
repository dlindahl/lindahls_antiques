class Photo < ActiveRecord::Base

  belongs_to :antique

  validates_presence_of :title, :page, :url, :allow_blank => false
  validates_numericality_of :width, :height, :allow_blank => false

  # This is actually missing Medium 640, but I'm unsure how to reference it
  validates_inclusion_of :size, :in => %w{square thumbnail small medium large original}, :allow_blank => false

end
