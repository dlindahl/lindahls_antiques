class Admin::EbayAuctionsController < ApplicationController
  respond_to :html, :json

  before_filter :retrieve_antique

  # GET /admin/antique/1/ebay_auctions
  # GET /admin/antique/1/ebay_auctions.json
  def index
    @ebay_auctions = EbayAuction.all
  end

  # GET /admin/antique/1/ebay_auctions/1
  # GET /admin/antique/1/ebay_auctions/1.json
  def show
    @ebay_auction = EbayAuction.find(params[:id])
  end

  # GET /admin/antique/1/ebay_auctions/new
  # GET /admin/antique/1/ebay_auctions/new.json
  def new
    @ebay_auction = @antique.ebay_auctions.build(
      :title => @antique.name,
      :description => @antique.description,
      :start_time => 15.minutes.from_now
    )
  end

  # GET /admin/antique/1/ebay_auctions/1/edit
  def edit
    @ebay_auction = EbayAuction.find(params[:id])
  end

  # POST /admin/antique/1/ebay_auctions
  # POST /admin/antique/1/ebay_auctions.json
  def create
    @ebay_auction = @antique.ebay_auctions.build( params[:ebay_auction] )
    flash[:notice] = t('flashes.ebay_auction.created') if @ebay_auction.save
    respond_with(@ebay_auction, :location => admin_antique_ebay_auctions_path)
  end

  # PUT /admin/antique/1/ebay_auctions/1
  # PUT /admin/antique/1/ebay_auctions/1.xml
  def update
    @ebay_auction = EbayAuction.find( params[:id] )
    if params[:ebay_auction].keys == ['listing_status']
      flash[:notice] = t("flashes.ebay_auction.listed.#{params[:ebay_auction][:listing_status]}") if @ebay_auction.update_attributes( params[:ebay_auction] )
    else
      flash[:notice] = t('flashes.ebay_auction.updated') if @ebay_auction.update_attributes( params[:ebay_auction] )
    end
    respond_with(@ebay_auction, :location => admin_antique_ebay_auctions_path)
  end

  # DELETE /admin/antique/1/ebay_auctions/1
  # DELETE /admin/antique/1/ebay_auctions/1.xml
  def destroy
    @ebay_auction = EbayAuction.find(params[:id])
    flash[:notice] = t('flashes.ebay_auction.destroyed') if @ebay_auction.destroy
    respond_with(@ebay_auction, :location => admin_antique_ebay_auctions_path)
  end

private

  def retrieve_antique
    @antique = Antique.find(params[:antique_id])
  end

end
