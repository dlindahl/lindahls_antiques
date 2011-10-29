ActiveAdmin.register Antique do

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
