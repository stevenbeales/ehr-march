Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( devise.css devise.js )
Rails.application.config.assets.precompile += %w( authy-form/form.authy.css authy-form/form.authy.js )