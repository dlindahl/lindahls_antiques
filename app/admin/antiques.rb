ActiveAdmin.register Antique do

  action_item :only => :show do
    link_to "Auction Off!", new_admin_antique_ebay_auction_path(antique)
  end

  index :as => :grid do |antique|
    render 'admin/antiques/grid_item', :antique => antique
  end

  show do
    attributes_table :sku, :name, :dimensions, :weight, :created_at, :updated_at

    panel "Description" do
      div(:class => 'description') { md( antique.description ) }
    end

    active_admin_comments
  end

  sidebar :photos, :only => [:show, :edit] do
    photos = antique.photos.square
    if photos.empty?
      render 'admin/photos/none'
    else
      # TODO: Figure out how to get render to use a layout.
      div pluralize(photos.size, 'photo')
      ul { render photos }
    end
  end

end
