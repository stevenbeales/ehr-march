Apitome.setup do |config|
  config.mount_at = nil
  config.root = nil
  config.doc_path = "docs"
  config.title = "API EHR Docs"
  config.layout = "layouts/application"
  config.code_theme = "solarized_light"
  config.css_override = "apitome/application"
  config.js_override = "apitome/application"
  # config.readme = "api.md"
  config.single_page = true
end
