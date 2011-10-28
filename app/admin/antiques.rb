ActiveAdmin.register Antique do

  index :as => :grid do |antique|
    # TODO: Move this to a partial
    link_to( image_tag( antique.photos.first.url ), admin_antique_path(antique) ) + antique.sku + "<br/>".html_safe + antique.name
  end

  show do
    attributes_table :sku, :name, :dimensions, :weight, :created_at, :updated_at

    panel "Description" do
      div { md( antique.description ) }
    end

    active_admin_comments
  end

end
