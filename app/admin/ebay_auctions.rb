ActiveAdmin.register EbayAuction do
  menu false

  action_item :only => :show do
    render 'list_now_button' if ebay_auction.draft?
  end

  controller do
    include Admin::ResourceFlashHelper

    def index
      raise HTTPStatus::Forbidden, "The :index action is forbidden"
    end

    def new
      new! do
        @ebay_auction.title = @ebay_auction.antique.name
        @ebay_auction.description = @ebay_auction.antique.description
        @ebay_auction.start_time = 15.minutes.from_now
      end
    end

    def create
      create! do |success, failure|
        failure.html do
          flash[:error] = resource_error_for @ebay_auction
          super
        end
        success.html { redirect_to admin_antique_ebay_auction_path( @ebay_auction.antique, @ebay_auction) }
      end
    end

    def update
      update! do |success, failure|
        success.html do
          flash[:notice] = t("flashes.ebay_auction.listed.#{params[:ebay_auction][:listing_status]}") if listing?
          redirect_to admin_antique_ebay_auction_path( @ebay_auction.antique, @ebay_auction)
        end
        failure.html do
          flash[:error] = resource_error_for @ebay_auction
          super
        end
      end
    end

    def destroy
      destroy! { admin_antique_path( @ebay_auction.antique ) }
    end

  protected

    def begin_of_association_chain
      Antique.find_by_id params[:antique_id]
    end

  private

    def listing?
      params[:ebay_auction].keys == ['listing_status']
    end

  end

  form :partial => "form"

end
