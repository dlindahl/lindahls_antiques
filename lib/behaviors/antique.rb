module Behaviors
  module Antique

    def sku_as_tag
      sku.downcase.gsub(/-/,'')
    end

    def dimensions
      "#{width}w x #{height}h x #{depth}d"
    end

    def thumbnail
      thumbnail? ? photos.square.first : nil
    end

  end
end