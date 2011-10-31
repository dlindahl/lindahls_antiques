ActiveAdmin.register Photo do
  menu false

  # TODO: Test this.
  # TODO: The flash colors are not right.
  collection_action :refresh do
    @antique = Antique.find(params[:antique_id])

    if @photos = @antique.photos.refresh!
      respond_with(@photos) do |format|
        format.html { redirect_to admin_antique_path(@antique), :flash => { :info => "Photos updated!" } }
      end
    else
      respond_with(nil, :status => :no_content) do |format|
        format.html { redirect_to admin_antique_path(@antique), :notice => "No photos found!" }
      end
    end
  end

end