class Antique < ActiveRecord::Base

  validates_presence_of :name, :description

  validates_numericality_of :weight, :width, :height, :depth, { :allow_nil => false }

  validates_uniqueness_of :sku, :allow_blank => false
  validates_format_of :sku, :with => /\w{3}-\d+\w?\Z/, :allow_blank => false

  def sku_as_tag
    sku.downcase.gsub(/-/,'')
  end

  has_many :photos do
    def refresh!
      @photos = Photo.fetch( proxy_owner )

      unless @photos.empty?
        proxy_target.clear

        @photos.each do |photo|
          photo_attributes = Photo.new.attributes.keys.inject({}) { |values, key| values[key.to_sym] = photo.send(key); values }

          proxy_owner.photos.build(photo_attributes)
        end
      end
    end
  end

end
