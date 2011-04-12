class Admin::AntiquesController < AdminController

  def index
    @antiques = Antique.all
  end

  def show
    @antique = Antique.find(params[:id])
  end

end