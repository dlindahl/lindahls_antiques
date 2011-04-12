class Admin::AntiquesController < AdminController

  def index
    @antiques = Antique.all
  end

end