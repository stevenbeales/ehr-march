require "test_helper"

describe LandingsController do
  describe "GET :index" do
    before do
      self.class.ancestors.must_include ActionController::TestCase
      @routes = Rails.application.routes
      get :index
    end

    def sign_in(user)
      login_as(user, scope: :user)
    end

    def sign_out
      logout(:user)
    end

    def default_url_options
      Rails.configuration.action_mailer.default_url_options
    end

    it { must_respond_with :success }
    it "renders langings/index" do
      must_render_template :index
    end
  end
end
