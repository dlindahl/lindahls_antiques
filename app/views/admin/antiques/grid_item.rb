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
      content_tag :span, current_auction_status, :class => status_tag_class
    end

  private

    def generate_view_link( content )
      link_to( content, admin_antique_path(antique) )
    end

    def current_auction_status
      @current_auction_status ||= antique.ebay_auctions.empty? ? "No Auctions" : antique.ebay_auctions.last.listing_status
    end

    def status_tag_class
      case current_auction_status
      when "draft"  then 'warning'
      when "active" then 'ok'
      when "ended"  then 'error'
      else ''
      end + " #{current_auction_status} status"
    end

  end
end