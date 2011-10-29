require 'behaviors/antique'
require 'interrogatives/antique'

class Antique < ActiveRecord::Base
  include Behaviors::Antique
  include Interrogatives::Antique

  after_create :retrieve_photos

  validates_presence_of :name, :description

  validates_numericality_of :weight, :width, :height, :depth, { :allow_nil => false, :greater_than_or_equal_to => 0.001 } # This is now an "or_equal_to" to fix an issue in Formtastic

  validates_uniqueness_of :sku, :allow_blank => false
  validates_format_of :sku, :with => /\w{3}-\d+\w?\Z/, :allow_blank => false

  has_many :photos, :dependent => :destroy do
    def refresh!
      photos = Photo.fetch( proxy_association.owner.sku_as_tag )

      unless photos.empty?
        proxy_association.target.clear

        photos.each do |photo|
          Photo::SIZES.each do |size|
            begin
              sized_photo = photo.send(size)
            rescue Exception => e
              Rails.logger.error("FLEAKR ERROR: Retrieving the #{size} version of #{photo.title} failed! (#{e.message})")
            else
              if sized_photo
                new_photo_attributes = {
                  :title => photo.title,
                  :size => size,
                  :page => sized_photo.page,
                  :url => sized_photo.url,
                  :width => sized_photo.width,
                  :height => sized_photo.height
                }
                if proxy_association.owner.new_record?
                  proxy_association.owner.photos.build(new_photo_attributes)
                else
                  proxy_association.owner.photos.create!(new_photo_attributes) # TODO: Test this
                end
              end
            end
          end
          self
        end
      end
    end
  end
  has_many :ebay_auctions, :dependent => :destroy

  accepts_nested_attributes_for :ebay_auctions, :photos

private

  def retrieve_photos
    photos.refresh!
  end

end
