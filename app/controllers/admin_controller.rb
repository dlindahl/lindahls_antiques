class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_user!

  layout 'admin/admin'

  def index
    redirect_to admin_dashboard_path
  end

private

  def authorize_user!
    if not current_user.try(:admin?)
      flash[:alert] = "Not authorized"
      redirect_to ''
    end
  end

end