ActiveAdmin.register Antique do

  action_item :only => :show do
    link_to "Auction Off!", new_admin_antique_ebay_auction_path(antique), :id => 'auction_off'
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

  sidebar :ebay_auctions, :only => [:show, :edit] do
    render 'admin/ebay_auctions/sidebar'
  end

  sidebar :photos, :only => [:show, :edit] do
    # TODO: Issue #20 - Rename template to photos/sidebar
    render 'admin/photos/photos', :photos => antique.photos.square.all
  end

  controller do
    include Admin::ResourceFlashHelper

    def create
      create! do |success, failure|
        failure.html do
          flash[:error] = resource_error_for @antique
          super
        end
        success.html { redirect_to admin_antique_path( @antique) }
      end
    end

    def update
      update! do |success, failure|
        failure.html do
          flash[:error] = resource_error_for @antique
          super
        end
      end
    end

  end

end
