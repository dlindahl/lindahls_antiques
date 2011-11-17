module Admin::Photos
  class Photos < ::Stache::View

    def humanized_photo_count
      pluralize(photos.size, 'photo')
    end

    def refresh_link
      link_to "Refresh?", refresh_admin_antique_photos_path(antique)
    end

  end
end