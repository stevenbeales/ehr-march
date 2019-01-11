class ApidocsController < Apitome::DocsController
  # before_action :authenticate_user!
  skip_before_filter :authenticate_user!

  def index
  end
end
