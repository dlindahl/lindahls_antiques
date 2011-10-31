module Admin::Photos
  class Photo < ::Stache::View

    def thumbnail
      img = image_tag photo.url, :size => '75x75'
      url = photo.medium.page
      link_to( img, url )
    end

  end
end