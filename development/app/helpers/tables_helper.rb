module TablesHelper
  def input(f, field, field_type, class_name)
    case field_type.to_s
      when 'String'
        f.input field.to_sym, input_html: { class: 'form-control', placeholder: field }
      when 'Integer'
        f.input field.to_sym, input_html: { class: 'form-control', placeholder: field }
      when 'Float'
        f.input field.to_sym, input_html: { class: 'form-control', placeholder: field }
      when 'Text'
        f.input field.to_sym, as: :text, input_html: { class: 'form-control', placeholder: field }
      when 'Time'
        f.input field.to_sym, input_html: { class: 'form-control', placeholder: field }
      when 'Enum'
        f.input field.to_sym, as: :select, collection: class_name.send(field.to_s.pluralize).to_a, input_html: { 'data-placeholder': field, 'data-theme': 'gray-lighter', 'data-arrow': '2x', 'data-padding': '3x', 'data-font': '1x', class: 'select2' }
      when 'Boolean'
        "<div class=checkbox-custom>
          #{f.check_box field.to_sym, label: false, id: field.to_sym}
          <label for=#{field.to_sym}>
            <span class=checkbox-icon-container>
              <span class=checkbox-icon></span>
            </span>
            <span class=checkbox-label>
              #{field.to_s.titleize}
            </span>
          </label>
        </div>".html_safe
    end
  end
end
