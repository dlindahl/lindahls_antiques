class Antique < ActiveRecord::Base

  after_create :retrieve_photos

  validates_presence_of :name, :description

  validates_numericality_of :weight, :width, :height, :depth, { :allow_nil => false, :greater_than => 0 }

  validates_uniqueness_of :sku, :allow_blank => false
  validates_format_of :sku, :with => /\w{3}-\d+\w?\Z/, :allow_blank => false

  has_many :photos, :dependent => :destroy do
    def refresh!
      photos = Photo.fetch( proxy_owner.sku_as_tag )

      unless photos.empty?
        proxy_target.clear

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
                if proxy_owner.new_record?
                  proxy_owner.photos.build(new_photo_attributes)
                else
                  proxy_owner.photos.create!(new_photo_attributes) # TODO: Test this
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

  def sku_as_tag
    sku.downcase.gsub(/-/,'')
  end

  def dimensions
    "#{width}w x #{height}h x #{depth}d"
  end

private

  def retrieve_photos
    photos.refresh!
  end

end
