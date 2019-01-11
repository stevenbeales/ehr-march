module AnyLogin
  module ApplicationHelper
    extend ActiveSupport::Concern

    def any_login_here
      render 'any_login/any_login' if AnyLogin.enabled && AnyLogin.verify_access_proc.call(self.controller)
    end

    if AnyLogin.enabled

      def any_login_id_input
        text_field_tag :id, '', :placeholder => 'ID', :id => 'any_login_id_input', :class => 'form-control'
      end

      def any_login_submit
        submit_tag AnyLogin.login_button_label, class: 'button'
      end

      def any_login_select
        collection = AnyLogin.collection
        select_options =
                        if AnyLogin.grouped?
                          grouped_options_for_select(collection)
                        else
                          options_for_select(collection)
                        end
        select_tag :selected_id, select_options, 'data-theme' => 'gray-lighter', 'data-arrow' => '2x', 'data-padding' => '1x', 'data-font' => '1x', class: 'select2'
      end

      def select_html_options
        options = {}
        #options = { :include_blank => true }
        options[:onchange] = 'AnyLogin.on_select_change();' if AnyLogin.login_on == :both
        options[:prompt] = AnyLogin.select_prompt
        options
      end

      def any_login_klasses
        klasses = []
        klasses << "any_login_#{AnyLogin.position || 'bottom_left'}"
        klasses << 'any_login_auto_show' if AnyLogin.auto_show
        klasses.join(' ')
      end

      def current_user_information
        if respond_to?(AnyLogin.provider::Controller.any_login_current_user_method) &&
           user = send(AnyLogin.provider::Controller.any_login_current_user_method)
          content_tag :span, :class => 'any_login_user_information' do
            if AnyLogin.name_method.is_a?(Symbol)
              raw("Current #{AnyLogin.klass_name}: #{h(user.send(AnyLogin.name_method)[0])} &mdash; ID: #{user.id}")
            else
              raw("Current #{AnyLogin.klass_name}: #{h(AnyLogin.name_method.call(user)[0])} &mdash; ID: #{user.id}")
            end
          end
        end
      end

    end

  end
end
