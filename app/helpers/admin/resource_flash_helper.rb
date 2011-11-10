module Admin::ResourceFlashHelper

  def resource_error_for( resource )
    render_to_string( :partial => 'admin/resource_error', :resource => resource ).html_safe
  end

end