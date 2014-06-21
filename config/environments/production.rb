Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = true

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  #config.action_mailer.delivery_method = :smtp
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.smtp_settings = {
    address:              'smtp.mailgun.org',
    port:                 587,
    domain:               'sandbox0b37c9b1a71f4d2d98dfbd99302dd8df.mailgun.org',
    #user_name:            ENV['gmail-user'],
    #password:             ENV['gmail-password'],
    user_name:            'emmanuel@sandbox0b37c9b1a71f4d2d98dfbd99302dd8df.mailgun.org',
    password:             5z5-se77fe62,
    authentication:       'plain',
    enable_starttls_auto: true  }

end
