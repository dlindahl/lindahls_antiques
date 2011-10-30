require 'behaviors/photo'

class Photo < ActiveRecord::Base
  belongs_to :antique

  SIZES = %w{square thumbnail small medium large original}.freeze

  validates_presence_of :title, :page, :url, :allow_blank => false
  validates_numericality_of :width, :height, :allow_blank => false

  # This is actually missing Medium 640, but I'm unsure how to reference it
  validates_inclusion_of :size, :in => SIZES, :allow_blank => false

  SIZES.each do |size|
    scope size, where(:size => size) # TODO: Only public photos?
  end

  include Behaviors::Photo

end
