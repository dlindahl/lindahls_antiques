ActiveAdmin.register EbayAuction do
  menu false

  action_item :only => :show do
    render 'list_now_button' if ebay_auction.draft?
  end

  controller do
    before_filter :fetch_antique, :except => [ :index ]

    def index
      raise HTTPStatus::Forbidden, "The :index action is forbidden"
    end

    def new
      @ebay_auction = @antique.ebay_auctions.build(
        :title        => @antique.name,
        :description  => @antique.description,
        :start_time   => 15.minutes.from_now
      )

      new!
    end

    def update
      @ebay_auction = EbayAuction.find_by_id params[:id]

      if @ebay_auction.update_attributes( params[:ebay_auction] )
        if params[:ebay_auction].keys == ['listing_status']
          flash[:notice] = t("flashes.ebay_auction.listed.#{params[:ebay_auction][:listing_status]}")
        else
          flash[:notice] = t('flashes.ebay_auction.updated')
        end
      end

      update!
    end

  private

    def fetch_antique
      @antique = Antique.find_by_id params[:antique_id]
    end
  end

  form :partial => "form"

end
