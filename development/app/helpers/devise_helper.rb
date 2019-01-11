module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages_password!
    return "" if resource.errors.empty?

    html = <<-HTML
    <div id="error_explanation" class="alert-passwords">
      <p>Sorry! There is no account associated with this email address.</p>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages_signup!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="main-title alerts-signup">
    <h1>#{sentence}</h1>
      #{messages}
    </div>
    HTML

    html.html_safe
  end

  # def devise_error_messages_signin!
  #       message = content_tag :p, flash.first[1], id: 'flash_alert'
  #       html = <<-HTML
  #       <div id="error_explanation" class="message alert-signin">
  #         #{message}
  #       </div>
  #       HTML
  #       html.html_safe
  # end
end
