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
      div { md( antique.description ) }
    end

    active_admin_comments
  end

end
