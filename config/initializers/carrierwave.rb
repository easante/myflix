CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage :fog
  
    config.fog_credentials = {
      :provider               => 'AWS',                          # required
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],       # required
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']    # required
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET']                  # required
#    config.fog_public     = false                                 # optional, defaults to true
  else
    config.storage :file
    config.enable_processing = Rails.env.development?
  end
end
