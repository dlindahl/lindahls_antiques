module Admin::Antiques
  class GridItem < ::Stache::View

    def view_antique_link
      generate_view_link antique.sku
    end

    def thumbnail
      content_tag(:figure, :class => 'thumbnail') do
        generate_view_link( image_tag( antique.thumbnail.url, :size => '75x75' ) ) if antique.thumbnail?
      end
    end

    def auction_status
      if antique.ebay_auctions.empty?
        "No Auctions"
      else
        antique.ebay_auctions.listing_status
      end
    end

  private

    def generate_view_link( content )
      link_to( content, admin_antique_path(antique) )
    end

  end
end