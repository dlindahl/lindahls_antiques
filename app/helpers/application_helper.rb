require 'rdiscount'

module ApplicationHelper

  def md( text )
    RDiscount.new(text).to_html.html_safe
  end

end
