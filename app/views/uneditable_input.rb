class UneditableInput < Formtastic::Inputs::StringInput

  def to_html
    input_wrapping do
      label_html <<
      template.content_tag(:span, object.send(method).to_s.titleize, input_html_options )
    end
  end

  def input_html_options
    super.tap do |options|
      options.delete(:maxlength)
    end
  end

end