class Admin::AntiquesController < AdminController
  respond_to :html, :json

  def index
    @antiques = Antique.all
  end

  def show
    @antique = Antique.find(params[:id])
  end

  def new
    @antique = Antique.new
  end

  def create
    @antique = Antique.new( params[:antique] )
    flash[:notice] = t('flashes.antique_created') if @antique.save
    respond_with(@antique, :location => admin_antiques_path)
  end

end