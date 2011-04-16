class Admin::PhotosController < AdminController

  respond_to :html, :json

  def refresh
    @antique = Antique.find(params[:antique_id])

    if @photos = @antique.photos.refresh!
      respond_with(@photos) do |format|
        format.html { redirect_to admin_antique_path(@antique), :flash => { :info => "Photos updated" } }
      end
    else
      respond_with(nil, :status => :no_content) do |format|
        format.html { redirect_to admin_antique_path(@antique), :notice => "No photos found!" }
      end
    end
  end

end