class BulmaFormBuilder < ActionView::Helpers::FormBuilder
  def bulma_form_element(form_method, attribute, options = {})
    label_text = options.delete(:label_text)
    no_label= options.delete(:no_label)
    options[:class] = [ "input", options[:class] ].reject(&:nil?).join(" ")
    @template.content_tag(:div, class: "field") do
      unless no_label
        label(attribute, label_text || attribute.to_s.titleize, class: "label") +
          control_helper(form_method, attribute, options)
      else
        control_helper(form_method, attribute, options)
      end
    end
  end

  private
    def control_helper(form_method, attribute, options)
      icon_left = options.delete(:icon_left)
      @template.content_tag(:div, class: icon_left.nil? ? "control" : "control has-icons-left") do
        if icon_left.nil?
          ActionView::Helpers::FormBuilder.instance_method(form_method).bind(self).call(attribute, options)
        else
          ActionView::Helpers::FormBuilder.instance_method(form_method).bind(self).call(attribute, options) +
            @template.content_tag(:span, class: "icon is-small is-left") do
              @template.content_tag(:i, nil, class: icon_left)
            end
        end
      end
    end
end
