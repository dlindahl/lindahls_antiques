module Admin::Photos
  class None < ::Stache::View

    def refresh_link
      link_to "Refresh?", refresh_admin_antique_photos_path(antique)
    end

  end
end